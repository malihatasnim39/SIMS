class BorrowingsController < ApplicationController
  before_action :set_borrowing, only: [ :edit, :update, :destroy ]
  before_action :set_club, only: [ :balance_sheet ]

  # Index action to show main borrowing page
  def index
    @borrowings = Borrowing.includes(:equipment, :club)
    @overdue = Borrowing.includes(:equipment, :club).where("due_date < ? AND status = ?", Date.today, "borrowed")
    @borrowed = Borrowing.includes(:equipment, :club).where(status: "borrowed")
  end

  # Super Club Borrowings action to show super clubs
  def super_club_borrowings
    @super_clubs = Club.where(Is_Super_Club: true)
    @super_club_borrowings = Borrowing.includes(:equipment, :club).where(club_id: @super_clubs.pluck(:Club_ID))
  end

  # Sub Club Borrowings action to show sub-clubs
  def sub_club_borrowings
    @sub_clubs = Club.where(Is_Super_Club: false)
  end
  def balance_sheet
    @borrowings = Borrowing.includes(:equipment, :club).where(club_id: params[:id])
    @club_name = params[:club_name]
  end

  def new
    @borrowing = Borrowing.new
    @equipments = Equipment.all
    @clubs = Club.all
  end

  # Create a new borrowing record
  def create
    @borrowing = Borrowing.new(borrowing_params)
    @borrowing.status ||= "borrowed"

    if @borrowing.save
      redirect_to borrowings_path, notice: "Borrowing record created successfully."
    else
      @equipments = Equipment.all
      @clubs = Club.all
      render :new
    end
  end

  # Edit an existing borrowing record
  def edit
    @equipments = Equipment.all
    @clubs = Club.all
  end

  # Update an existing borrowing record
  def update
    if @borrowing.update(borrowing_params)
      redirect_to borrowings_path, notice: "Borrowing record updated successfully."
    else
      @equipments = Equipment.all
      @clubs = Club.all
      render :edit
    end
  end

  # Delete an existing borrowing record
  def destroy
    @borrowing.destroy
    redirect_to borrowings_path, notice: "Borrowing record deleted successfully."
  end

  private

  # Set borrowing for actions that require it
  def set_borrowing
    @borrowing = Borrowing.find(params[:id])
  end

  # Set club for balance sheet action
  def set_club
    @club = Club.find(params[:id])
  end

  # Strong parameters for borrowing
  def borrowing_params
    params.require(:borrowing).permit(:equipment_id, :club_id, :borrow_date, :due_date, :status, :quantity)
  end
end
