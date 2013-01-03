require 'pty'

module Caterer
  module Communication
    class Rsync
      
      attr_reader :server

      class << self
        
        def available?
          `command -v rsync &>/dev/null`
          $?.exitstatus == 0 ? true : false
        end

      end

      def initialize(server)
        @server = server
        @logger = Log4r::Logger.new("caterer::communication::rsync")
      end

      def sync(from, to)
        exit_status = nil
        PTY.spawn(rsync_cmd(from, to)) do |stdout, stdin, pid|
          eof = false
          until eof do
            begin
              out = stdout.readpartial(4096)
              if out.match /password:/
                stdin.puts server.password
              else
                @logger.debug("stdout: #{out}")
              end
            rescue EOFError
              eof = true
            end
          end
          Process.wait(pid)
          exit_status = $?.exitstatus
        end
        exit_status
      end

      protected

      def rsync_cmd(from, to)
        "rsync -zr -e '#{ssh_cmd}' --delete #{from} #{server.username}@#{server.host}:#{to}"
      end

      def ssh_cmd
        cmd = "ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
        cmd += " -i #{server.key}" unless server.key.nil?
        cmd += " -p #{server.port}" unless server.port == 22
        cmd
      end

    end
  end
end