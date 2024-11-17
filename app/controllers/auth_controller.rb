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
  # Debugging: Print email and password
  puts "Attempting to sign in with email: #{user_params[:email]}"
  puts "Password: #{user_params[:password]}"

  response = supabase_client.sign_in(user_params[:email], user_params[:password])

  # Debugging: Print the full response for troubleshooting
  puts "Response from Supabase: #{response}"

  if response.success?
    session[:token] = response.parsed_response["access_token"]
    redirect_to root_path, notice: "Successfully signed in!"
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
