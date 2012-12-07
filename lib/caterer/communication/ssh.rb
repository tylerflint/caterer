require 'timeout'
require 'net/ssh'
require 'log4r'

module Caterer
  module Communication
    class SSH
      
      def initialize(server)
        @server     = server
        @connection = nil
        @logger     = Log4r::Logger.new("caterer::communication::ssh")
      end

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

        ssh_opts = @server.ssh_opts

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

        @logger.info("Connecting to SSH: #{ssh_info[:host]}:#{ssh_info[:port]}")
        connection = retryable(:tries => ssh_opts[:max_tries], :on => exceptions) do
          Net::SSH.start(ssh_info[:host], ssh_info[:username], ssh_info)
        end

        @connection = connection

        # This is hacky but actually helps with some issues where
        # Net::SSH is simply not robust enough to handle... see
        # issue #391, #455, etc.
        sleep 4

        # Yield the connection that is ready to be used and
        # return the value of the block
        return yield connection if block_given?
      end

    end
  end
end