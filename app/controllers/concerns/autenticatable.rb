module Authenticatable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
  end

  private

  def authenticate_user!
    unless current_user
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end

  def current_user
    return @current_user if defined?(@current_user)
    header = request.headers["Authorization"]
    return nil unless header

    token = header.split(" ").last
    payload = Supabase::Client.new.verify_jwt(token)
    return nil unless payload

    @current_user = payload.first["sub"]
  end
end
