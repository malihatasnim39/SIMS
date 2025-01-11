class PicController < ApplicationController
  before_action :require_pic!

  def dashboard
    flash[:success] = "Welcome PIC."
    @club_id = session[:club_id]
    render "auth/PIC/dashboard"
    # Add any other data needed for the PIC dashboard
  end
end
