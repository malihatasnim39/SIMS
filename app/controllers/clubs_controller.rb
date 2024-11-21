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

  def index
    @clubs = Club.all
  end

  def edit
    @club = Club.find(params[:id])
    @super_clubs = Club.where(Is_Super_Club: true)
  end

  def update
    @club = Club.find(params[:id])
    if @club.update(club_params)
      redirect_to clubs_path, notice: "Club updated successfully."
    else
      @super_clubs = Club.where(Is_Super_Club: true)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @club = Club.find(params[:id])
    @club.children.update_all(Parent_Club: nil) # Nullify the parent club reference
    @club.destroy
    redirect_to clubs_path, notice: "Club deleted successfully."
  end

  private

  def club_params
    params.require(:club).permit(:Is_Super_Club, :Club_Name, :Parent_Club, :Budget)
  end
end
