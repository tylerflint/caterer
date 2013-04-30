module Caterer
  module Util
    module Shell
      
      # strategy:
      # 1- escape the escapes
      # 2- escape quotes
      # 3- escape dollar signs
      def escape(cmd)
        cmd.gsub!(/\\/, "\\\\\\")
        cmd.gsub!(/"/, "\\\"")
        cmd.gsub!(/\$/, "\\$")
        cmd
      end

      def bash(cmd)
        "bash -c \"#{escape(cmd)}\""
      end

      def su(user, cmd)
        "su #{user} -l -c \"#{escape(cmd)}\""
      end

      def env(vars)
        vars ||= {}
        env = ''
        vars.each do |key, val|
          env += " " if not env == ''
          env += env_string(key, val)
        end
        (env == '')? env : "#{env} "
      end

      def env_string(key, val)
        key = key.to_s if not key.is_a? String
        %Q{#{key.upcase}="#{escape(val)}"}
      end

    end
  end
end