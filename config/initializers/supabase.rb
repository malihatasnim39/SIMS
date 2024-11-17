require "httparty"

module Supabase
  class Client
    include HTTParty
    base_uri "https://drgdtfebkffeizxxteto.supabase.co"

    def initialize
      @options = {
        headers: {
          "apikey" => ENV["SUPABASE_ANON_KEY"],
          "Content-Type" => "application/json"
        }
      }
    end

    def sign_up(email, password)
      endpoint = "/auth/v1/signup"
      body = {
        email: email,
        password: password
      }

      self.class.post(
        endpoint,
        body: body.to_json,
        headers: @options[:headers]
      )
    end

    def sign_in(email, password)
      endpoint = "/auth/v1/token?grant_type=password"
      body = {
        email: email,
        password: password
      }

      self.class.post(
        endpoint,
        body: body.to_json,
        headers: @options[:headers]
      )
    end

    def verify_jwt(token)
      JWT.decode(token, ENV["SUPABASE_JWT_SECRET"], true, { algorithm: "HS256" })
    rescue JWT::DecodeError
      nil
    end
  end
end
