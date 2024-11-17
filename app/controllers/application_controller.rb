class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  private

  def authenticate_user!
    unless current_user
      flash[:error] = "Please sign in to continue"
      redirect_to signin_path
    end
  end

  def current_user
    return @current_user if defined?(@current_user)
    token = session[:token]
    return nil unless token

    payload = Supabase::Client.new.verify_jwt(token)
    return nil unless payload

    @current_user = payload.first["sub"]
  rescue JWT::DecodeError
    nil
  end
end
