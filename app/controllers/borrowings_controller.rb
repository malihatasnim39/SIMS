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
    @sub_club_borrowings = Borrowing.includes(:equipment, :club).where(club_id: @sub_clubs.pluck(:Club_ID))
  end

  def balance_sheet
    @borrowings = Borrowing.includes(:equipment, :club).where(club_id: @club.id)
  end

  def new
    @borrowing = Borrowing.new
    @equipments = Equipment.all
    @clubs = Club.all
  end

  def create
    @borrowing = Borrowing.new(borrowing_params)
    if @borrowing.save
      redirect_to borrowings_path, notice: "Borrowing record created successfully."
    else
      @equipments = Equipment.all
      @clubs = Club.all
      flash[:alert] = @borrowing.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @equipments = Equipment.all
    @clubs = Club.all
  end

  def update
    old_quantity = @borrowing.quantity
    old_equipment = @borrowing.equipment

    if @borrowing.update(borrowing_params)
      if old_equipment != @borrowing.equipment || old_quantity != @borrowing.quantity
        old_equipment.update!(stock: old_equipment.stock + old_quantity)
        @borrowing.reduce_stock_on_borrow
      end
      redirect_to borrowings_path, notice: "Borrowing record updated successfully."
    else
      @equipments = Equipment.all
      @clubs = Club.all
      flash[:alert] = @borrowing.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @borrowing.destroy
    redirect_to borrowings_path, notice: "Borrowing record deleted successfully."
  end

  private

  def set_borrowing
    @borrowing = Borrowing.find(params[:id])
  end

  def set_club
    @club = Club.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to borrowings_path, alert: "Club not found."
  end

  def borrowing_params
    params.require(:borrowing).permit(:equipment_id, :club_id, :borrow_date, :due_date, :quantity, :status)
  end
end
