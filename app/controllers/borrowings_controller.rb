class BorrowingsController < ApplicationController
  before_action :set_borrowing, only: [ :edit, :update, :destroy ]
  before_action :set_club, only: [ :balance_sheet ]

  def index
    # Update overdue records before fetching them
    Borrowing.where("due_date < ? AND status = ?", Date.today, "borrowed").update_all(status: "overdue")

    # Fetch the updated records
    @borrowings = Borrowing.includes(:equipment, :club)
    @overdue = Borrowing.includes(:equipment, :club).where(status: "overdue")
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
    equipment = Equipment.find(@borrowing.equipment_id)

    if equipment.stock >= @borrowing.quantity
      if @borrowing.save
        equipment.update(stock: equipment.stock - @borrowing.quantity)
        redirect_to borrowing_notification_path, notice: "Borrowing record created successfully."
      else
        @equipments = Equipment.all
        @clubs = Club.all
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
    new_quantity = borrowing_params[:quantity].to_i
    new_equipment = Equipment.find(borrowing_params[:equipment_id])

    available_stock = if old_equipment == new_equipment
                        new_equipment.stock + old_quantity
    else
                        new_equipment.stock
    end

    if new_quantity > available_stock
      redirect_to borrowing_notification_path, alert: "Not enough stock available for the selected item. Update failed."
    else
      if @borrowing.update(borrowing_params)
        # Restore stock for old equipment if it was changed
        old_equipment.update(stock: old_equipment.stock + old_quantity) if old_equipment && old_equipment != new_equipment
        # Reduce stock for new equipment
        new_equipment.update(stock: new_equipment.stock - new_quantity)
        redirect_to borrowing_notification_path, notice: "Borrowing record updated successfully."
      else
        @equipments = Equipment.all
        @clubs = Club.all
        redirect_to borrowing_notification_path, alert: @borrowing.errors.full_messages.to_sentence
      end
    end
  end

  def destroy
    ActiveRecord::Base.transaction do
      # Delete all notifications related to this borrowing
      Notification.where(borrowing_id: @borrowing.id).destroy_all

      # Now safely delete the borrowing
      @borrowing.destroy
    end

    redirect_to borrowing_notification_path, notice: "Borrowing record and associated notifications deleted successfully."
  rescue ActiveRecord::RecordInvalid => e
    redirect_to borrowing_notification_path, alert: "Failed to delete borrowing: #{e.message}"
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
