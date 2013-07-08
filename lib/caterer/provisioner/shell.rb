require 'digest'
require 'tilt'
require 'erubis'
require 'erb'

module Caterer
  module Provisioner
    class Shell < Base

      attr_accessor :path, :inline, :args

      def initialize(image, opts={})
        @image  = image
        @path   = opts[:path] if opts[:path]
        @inline = opts[:inline] if opts[:inline]
        @args   = opts[:args] if opts[:args]
      end

      # config dsl

      def path(path)
        @path = path
      end

      def inline(inline)
        @inline = inline
      end

      def args(args)
        @args = args
      end

      def errors
        errors = {}
        
        if not @path and not @inline
          errors[:action] = "cannot be determined. Please set 'inline' or 'script'"
        end

        if errors.length > 0
          errors
        end

      end

      def prepare(server)
        # create lib dir
        server.ssh.sudo "mkdir -p #{dest_lib_dir}", :stream => true
        server.ssh.sudo "chown -R #{server.username} #{dest_lib_dir}", :stream => true

        # create script
        server.ui.info "Generating shell script..."
        server.ssh.upload(StringIO.new(script_content), dest_script_path)
        server.ssh.sudo "chmod +x #{dest_script_path}", :stream => true
      end

      def provision_cmd
        "#{dest_script_path} #{@args}"
      end

      def dest_lib_dir
        "#{image.lib_dir}/shell"
      end

      def dest_script_path
        "#{dest_lib_dir}/#{uuid}"
      end

      def uuid
        @uuid ||= ::Digest::MD5.hexdigest((@inline or @path))
      end

      def script_content
        if @inline
          Tilt.new(File.expand_path('../../../templates/provisioner/shell/script.erb', __FILE__)).render(self)          
        else
          File.read @path
        end
      end

    end
  end
end