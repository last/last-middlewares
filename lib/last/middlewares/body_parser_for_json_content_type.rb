require 'multi_json'

module Last
module Middlewares

  class BodyParserForJsonContentType
    JSON_CONTENT_TYPE = 'application/json'.freeze
    POST_BODY_KEY     = 'rack.input'.freeze
    FORM_INPUT_KEY    = 'rack.request.form_input'.freeze
    FORM_HASH_KEY     = 'rack.request.form_hash'.freeze

    def initialize(app)
      @app = app
    end

    def call(env)
      if Rack::Request.new(env).media_type == JSON_CONTENT_TYPE && (body = env[POST_BODY_KEY].read).length != 0
        env[POST_BODY_KEY].rewind
        env.update(FORM_HASH_KEY => MultiJson.load(body), FORM_INPUT_KEY => env[POST_BODY_KEY])
      end

      @app.call(env)
    end
  end

end
end
