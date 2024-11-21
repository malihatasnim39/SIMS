class ClubsController < ApplicationController
  def new
    @club = Club.new
    @super_clubs = Club.where(Is_Super_Club: true)
  end

  def create
    @club = Club.new(club_params)
    if @club.save
      redirect_to club_created_path
    else
      @super_clubs = Club.where(Is_Super_Club: true)
      render :new, status: :unprocessable_entity
    end
  end

  private

  def club_params
    params.require(:club).permit(:Is_Super_Club, :Club_Name, :Parent_Club, :Budget)
  end
end
