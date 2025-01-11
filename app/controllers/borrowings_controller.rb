class BorrowingsController < ApplicationController
  before_action :set_borrowing, only: [ :edit, :update, :destroy ]

  # Index
  def index
    @overdue = Borrowing.where("due_date < ? AND status = ?", Date.today, "borrowed")
                        .update_all(status: "overdue")

    @borrowed = Borrowing.where(status: "borrowed")
    @returned = Borrowing.where(status: "returned")
  end

  # Super Club Borrowings
  def super_club_borrowings
    @super_club_borrowings = Borrowing.joins(:club).includes(:equipment, :club)
                                      .where(clubs: { Is_Super_Club: true })
  end

  # Sub Club Borrowings
  def sub_club_borrowings
    @sub_club_borrowings = Borrowing.joins(:club).includes(:equipment, :club)
                                    .where(clubs: { Is_Super_Club: false })
  end

  # New Record
  def new
    @borrowing = Borrowing.new
    @equipments = Equipment.all
    @clubs = Club.all
  end

  # Create Record
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

  # Edit
  def edit
    @equipments = Equipment.all
    @clubs = Club.all
  end

  # Update
  def update
    if @borrowing.update(borrowing_params)
      redirect_to borrowings_path, notice: "Borrowing record updated successfully."
    else
      @equipments = Equipment.all
      @clubs = Club.all
      render :edit
    end
  end

  # Destroy
  def destroy
    @borrowing.destroy
    redirect_to borrowings_path, notice: "Borrowing record deleted successfully."
  end

  def return
    borrowing = Borrowing.find(params[:id])
    if borrowing.update(status: "returned")
      Notification.where(borrowing_id: borrowing.id).destroy_all # Remove associated notifications
      flash[:success] = "Borrowing status updated to returned."
    else
      flash[:error] = "Failed to update borrowing status."
    end
    redirect_to pic_dashboard_path # Adjust to your dashboard route
  end

  private

  def set_borrowing
    @borrowing = Borrowing.find(params[:id])
  end

  # before_action :require_pic! # Ensure only PIC users can access this action



  def borrowing_params
    params.require(:borrowing).permit(:equipment_id, :club_id, :borrow_date, :due_date, :status)
  end
end
