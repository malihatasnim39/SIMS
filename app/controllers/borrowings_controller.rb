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
    @club = Club.find(params[:id]) # Find the club by the ID passed in the URL
    @borrowings = Borrowing.includes(:equipment, :person_in_charge).where(club_id: @club.id)

    # Handle search functionality
    if params[:search].present?
      search_term = params[:search].downcase
      @borrowings = @borrowings.select do |borrowing|
        (borrowing.equipment&.Equipment_Name&.downcase&.include?(search_term)) ||
        (borrowing.person_in_charge&.name&.downcase&.include?(search_term))
      end
    end
  end

  def new
    @borrowing = Borrowing.new
    @clubs = Club.all
    @equipments = Equipment.all
  end

  def create
    @borrowing = Borrowing.new(borrowing_params)
    equipment = Equipment.find(@borrowing.equipment_id)

    if equipment.stock >= @borrowing.quantity
      if @borrowing.save
        equipment.update(stock: equipment.stock - @borrowing.quantity)
        redirect_to borrowing_notification_path, notice: "Borrowing record created successfully."
      else
        @equipments = Equipment.all
        @clubs = Club.all
        flash[:alert] = @borrowing.errors.full_messages.to_sentence
        redirect_to borrowing_notification_path, alert: "Failed to create borrowing record."
      end
    else
      redirect_to borrowing_notification_path, alert: "Not enough stock available for the selected item."
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
        old_equipment.update(stock: old_equipment.stock + old_quantity)
        @borrowing.equipment.update(stock: @borrowing.equipment.stock - @borrowing.quantity)
      end
      redirect_to borrowing_notification_path, notice: "Borrowing record updated successfully."
    else
      @equipments = Equipment.all
      @clubs = Club.all
      flash[:alert] = @borrowing.errors.full_messages.to_sentence
      redirect_to borrowing_notification_path, alert: "Failed to update borrowing record."
    end
  end

  def destroy
    equipment = @borrowing.equipment
    equipment.update(stock: equipment.stock + @borrowing.quantity)
    @borrowing.destroy
    redirect_to borrowing_notification_path, notice: "Borrowing record deleted successfully."
  end

  def equipment_by_club
    club_id = params[:club_id]
    equipments = Equipment.where(Club_ID: club_id)

    if equipments.any?
      render json: { equipments: equipments.map { |e| { id: e.Equipment_ID, name: e.Equipment_Name, stock: e.stock } } }
    else
      render json: { equipments: [] }, status: :not_found
    end
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
