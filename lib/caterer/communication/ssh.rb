require 'timeout'
require 'net/ssh'
require 'net/scp'
require 'log4r'

module Caterer
  module Communication
    class SSH
      include Util::ANSIEscapeCodeRemover
      include Util::Retryable
      
      def initialize(server)
        @server     = server
        @connection = nil
        @logger     = Log4r::Logger.new("caterer::communication::ssh")
      end

      def ready?
        @logger.debug("Checking whether SSH is ready...")

        Timeout.timeout(30) do
          connect
        end

        # If we reached this point then we successfully connected
        @logger.info("SSH is ready!")
        true
      rescue => e
        # The above errors represent various reasons that SSH may not be
        # ready yet. Return false.
        @logger.info("SSH not up: #{e.inspect}")
        return false
      end

      def execute(command, opts={}, &block)
        connect do |connection|
          shell_execute(connection, command, opts, &block)
        end
      end

      def sudo(command, opts={}, &block)
        execute(command, opts.merge({:sudo => true}), &block)
      end

      def upload(from, to, recursive=false)
        @logger.debug("Uploading: #{from} to #{to}")

        # Do an SCP-based upload...
        connect do |connection|
          opts = {}
          opts[:recursive] = true if File.directory?(from)
          scp = Net::SCP.new(connection)
          scp.upload!(from, to, opts)
        end
      rescue Net::SCP::Error => e
        # If we get the exit code of 127, then this means SCP is unavailable.
        raise "scp unavailable" if e.message =~ /\(127\)/

          # Otherwise, just raise the error up
          raise
      end

      protected

      # Opens an SSH connection and yields it to a block.
      def connect
        if @connection && !@connection.closed?
          # There is a chance that the socket is closed despite us checking
          # 'closed?' above. To test this we need to send data through the
          # socket.
          begin
            @connection.exec!("")
          rescue IOError
            @logger.info("Connection has been closed. Not re-using.")
            @connection = nil
          end

          # If the @connection is still around, then it is valid,
          # and we use it.
          if @connection
            @logger.debug("Re-using SSH connection.")
            return yield @connection if block_given?
            return
          end
        end

        # Connect to SSH, giving it a few tries
        connection = nil
        # These are the exceptions that we retry because they represent
        # errors that are generally fixed from a retry and don't
        # necessarily represent immediate failure cases.
        exceptions = [
          Errno::ECONNREFUSED,
          Errno::EHOSTUNREACH,
          Net::SSH::Disconnect,
          Timeout::Error
        ]

        @logger.info("Connecting to SSH: (#{@server.host}:#{@server.port}")
        connection = retryable(:tries => 10, :on => exceptions) do
          Net::SSH.start(@server.host, @server.username, @server.ssh_opts)
        end

        @connection = connection

        # This is hacky but actually helps with some issues where
        # Net::SSH is simply not robust enough to handle... see
        # issue #391, #455, etc.
        # sleep 4

        # Yield the connection that is ready to be used and
        # return the value of the block
        return yield connection if block_given?
      end

      # Executes the command on an SSH connection within a login shell.
      def shell_execute(connection, command, opts={})

        opts[:sudo] ||= false
        opts[:stream] ||= false

        @logger.info("Execute: #{command} (opts=#{opts.inspect})")
        exit_status = nil

        # Determine the shell to execute. If we are using `sudo` then we
        # need to wrap the shell in a `sudo` call.
        shell = "bash -l"
        shell = "sudo -H #{shell}" if opts[:sudo]

        # Open the channel so we can execute or command
        channel = connection.open_channel do |ch|
          ch.exec(shell) do |ch2, _|
            # Setup the channel callbacks so we can get data and exit status
            ch2.on_data do |ch3, data|
              if block_given?
                # Filter out the clear screen command
                data = remove_ansi_escape_codes(data)
                @logger.debug("stdout: #{data}")
                yield :stdout, data
              end
              if opts[:stream]
                @server.ui.success data.chomp
              end
            end

            ch2.on_extended_data do |ch3, type, data|
              if block_given?
                # Filter out the clear screen command
                data = remove_ansi_escape_codes(data)
                @logger.debug("stderr: #{data}")
                yield :stderr, data
              end
              if opts[:stream]
                @server.ui.error data.chomp
              end
            end

            ch2.on_request("exit-status") do |ch3, data|
              exit_status = data.read_long
              @logger.debug("Exit status: #{exit_status}")
            end

            # Set the terminal
            ch2.send_data "export TERM=vt100\n"

            # Output the command
            ch2.send_data "#{command}\n"

            # Remember to exit or this channel will hang open
            ch2.send_data "exit\n"
          end
        end

        # Wait for the channel to complete
        channel.wait

        # Return the final exit status
        return exit_status
      end

    end
  end
end