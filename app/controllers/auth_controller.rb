class AuthController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :new, :sign_up, :signin_new, :sign_in ]

  def new
    @user = User.new
  end

  def sign_up
    response = supabase_client.sign_up(user_params[:email], user_params[:password])

    if response.success?
      flash[:success] = "Successfully signed up! Please sign in."
      redirect_to signin_path
    else
      flash.now[:error] = response.parsed_response["error_description"] || "Error during signup"
      render :new, status: :unprocessable_entity
    end
  end

  def signin_new
  end

  def sign_in
    response = supabase_client.sign_in(user_params[:email], user_params[:password])

    if response.success?
      session[:token] = response.parsed_response["access_token"]
      user_info = supabase_client.get_user_info(response.parsed_response["access_token"])
      user = User.new(id: user_info["id"], email: user_params[:email])
      session[:user_type] = user.is_supervisor
      session[:club_id] = user.club_id
      redirect_to signed_in_path
    else
      flash.now[:error] = "Response from Supabase: #{response}"
      render :signin_new, status: :unauthorized
    end
  end

  def sign_out
    session.delete(:token)
    flash[:notice] = "Successfully signed out"
    redirect_to signin_path
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

  def supabase_client
    @supabase_client ||= Supabase::Client.new
  end
end
