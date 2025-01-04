class BorrowingsController < ApplicationController
  before_action :set_borrowing, only: [ :edit, :update, :destroy ]
  before_action :set_club, only: [ :balance_sheet ]

  def index
    @borrowings = Borrowing.includes(:equipment, :club)
    @overdue = Borrowing.includes(:equipment, :club).where("due_date < ? AND status = ?", Date.today, "borrowed")
    @borrowed = Borrowing.includes(:equipment, :club).where(status: "borrowed")
  end

  def super_club_borrowings
    @super_clubs = Club.where(Is_Super_Club: true)
    @super_club_borrowings = Borrowing.includes(:equipment, :club).where(club_id: @super_clubs.pluck(:Club_ID))
  end

  def sub_club_borrowings
    @sub_clubs = Club.where(Is_Super_Club: false)
  end

  def balance_sheet
    @borrowings = Borrowing.includes(:equipment, :club, :person_in_charge).where(club_id: params[:id])
    @club = Club.find(params[:id])
  end

  def new
    @borrowing = Borrowing.new
    @equipments = Equipment.all
    @clubs = Club.all
  end

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

  def edit
    @equipments = Equipment.all
    @clubs = Club.all
  end

  def update
    if @borrowing.update(borrowing_params)
      redirect_to borrowings_path, notice: "Borrowing record updated successfully."
    else
      @equipments = Equipment.all
      @clubs = Club.all
      render :edit
    end
  end

  def destroy
    Rails.logger.debug "Destroy action invoked for Borrowing ID: #{params[:id]}"
    @borrowing.destroy
    Rails.logger.debug "Borrowing record deleted successfully."
    redirect_to borrowings_path, notice: "Borrowing record deleted successfully."
  rescue ActiveRecord::RecordNotFound
    Rails.logger.debug "Borrowing record not found for ID: #{params[:id]}"
    redirect_to borrowings_path, alert: "Borrowing record not found."
  end

  private

  def set_borrowing
    @borrowing = Borrowing.find(params[:id])
  end

  def set_club
    @club = Club.find(params[:id])
  end

  def borrowing_params
    params.require(:borrowing).permit(:equipment_id, :club_id, :borrow_date, :due_date, :status, :quantity)
  end
end
