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

      def errors
        errors = {}
        
        if not @path and not @inline
          errors[:action] = "cannot be determined. Please set either 'inline' or 'script'"
        end

        if errors.length > 0
          errors
        end

      end

      def prepare(server)
        # create the destination directories
      end

      def provision_cmd
        # exec something
      end

    end
  end
end