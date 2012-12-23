require 'pty'

module Caterer
  module Communication
    class Rsync
      
      class << self
        
        def available?
          `command -v rsync &>/dev/null`
          $?.exitstatus == 0 ? true : false
        end

      end

      def initialize(server)
        @server = server
        @logger = Log4r::Logger.new("caterer::communication::ssh")
      end

      def sync(from, to)
        PTY.spawn(rsync_cmd(from, to)) do |stdout, stdin|
          eof = false
          until eof do
            begin
              out = stdout.readpartial(4096)
              if out.match /password:/
                stdin.puts @server.password
              else
                print out if print_worthy out
              end
            rescue EOFError
              eof = true
            end
          end
        end
      end

      protected

      def print_worthy(data)
        [
          /^\r\n$/, # empty lines
          /^Warning: Permanently added/, # key added nonsense
        ].each do |cruft|
          if data.match cruft
            return false
          end
        end
        true
      end

      def rsync_cmd(from, to)
        "rsync -zr -e 'ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -p #{@server.port}' --delete #{from} #{@server.username}@#{@server.host}:#{to}"
      end

    end
  end
end