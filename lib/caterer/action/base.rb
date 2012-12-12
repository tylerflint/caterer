module Caterer
  module Action
    class Base
      def initialize(app, env)
        @app = app
        @env = env
      end
    end
  end
end