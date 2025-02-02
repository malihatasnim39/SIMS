class BorrowingsController < ApplicationController
  before_action :set_borrowing, only: [ :edit, :update, :destroy ]
  before_action :set_club, only: [ :balance_sheet ]

  def index
    Borrowing.where("due_date < ? AND status = ?", Date.today, "borrowed")
             .update_all(status: "overdue")
    @borrowings = Borrowing.includes(:equipment, :club)
    @overdue = Borrowing.includes(:equipment, :club).where(status: "overdue")
    @borrowed = Borrowing.includes(:equipment, :club).where(status: [ "borrowed", "overdue" ])
  end

  def super_club_borrowings
    @super_clubs = Club.where(Is_Super_Club: true)
    @super_club_borrowings = Borrowing.includes(:equipment, :club)
                                       .where(club_id: @super_clubs.pluck(:Club_ID))
  end

  def sub_club_borrowings
    @sub_clubs = Club.where(Is_Super_Club: false)
    @sub_club_borrowings = Borrowing.includes(:equipment, :club)
                                     .where(club_id: @sub_clubs.pluck(:Club_ID))
  end

  def balance_sheet
    @club = Club.find(params[:id])
    @borrowings = Borrowing.includes(:equipment).where(club_id: @club.id)

    if params[:search].present?
      search_term = params[:search].downcase
      @borrowings = @borrowings.select do |borrowing|
        borrowing.equipment&.Equipment_Name&.downcase&.include?(search_term) ||
        borrowing.status&.downcase&.include?(search_term)
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
    equipment = Equipment.find_by(Equipment_ID: @borrowing.equipment_id)

    if equipment.nil?
      redirect_to new_borrowing_path, alert: "Selected equipment does not exist."
      return
    end

    if equipment.stock.nil? || equipment.stock < @borrowing.quantity
      redirect_to borrowing_notification_path, alert: "Not enough stock available for the selected item."
      return
    end

    if @borrowing.save
      equipment.update(stock: equipment.stock - @borrowing.quantity)
      redirect_to borrowings_path, notice: "Borrowing record created successfully."
    else
      redirect_to borrowing_notification_path, alert: "Failed to create borrowing record. Please try again."
    end
  end

  def edit
    @borrowed = Borrowing.find_by(id: params[:id])
    if @borrowed.nil?
      redirect_to borrowings_path, alert: "Borrowing record not found."
    else
      @equipments = Equipment.all
      @clubs = Club.all
    end
  end

  def update
    old_quantity = @borrowing.quantity
    old_equipment = @borrowing.equipment
    new_quantity = borrowing_params[:quantity].to_i
    new_equipment = Equipment.find_by(Equipment_ID: borrowing_params[:equipment_id])

    if new_equipment.nil?
      redirect_to borrowing_notification_path, alert: "Selected equipment does not exist."
      return
    end

    available_stock = if old_equipment == new_equipment
                        (new_equipment.stock || 0) + old_quantity
    else
                        new_equipment.stock || 0
    end

    if new_quantity > available_stock
      redirect_to borrowing_notification_path, alert: "Not enough stock available for the selected item. Update failed."
    else
      if @borrowing.update(borrowing_params)
        old_equipment.update(stock: (old_equipment.stock || 0) + old_quantity) if old_equipment && old_equipment != new_equipment
        new_equipment.update(stock: (new_equipment.stock || 0) - new_quantity)
        redirect_to borrowings_path, notice: "Borrowing record updated successfully."
      else
        redirect_to borrowing_notification_path, alert: "Failed to update borrowing record. Please try again."
      end
    end
  end

  def destroy
    @borrowing.destroy
    redirect_to borrowings_path, notice: "Borrowing record deleted successfully."
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
    @borrowing = Borrowing.find_by(id: params[:id])
    unless @borrowing
      redirect_to borrowings_path, alert: "Borrowing record not found."
    end
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
