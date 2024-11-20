class BorrowingsController < ApplicationController
  def index
    @borrowings = Borrowing.includes(:equipment).all

    Rails.logger.debug "Borrowings: #{@borrowings.map { |b| { id: b.id, due_date: b.due_date } }}"

    @overdue_items = @borrowings.select do |b|
      overdue = b.due_date.present? && b.due_date.to_date < Date.today
      Rails.logger.debug "Borrowing #{b.id} is overdue: #{overdue}"
      overdue
    end
  end


  def new
    @borrowing = Borrowing.new
    @clubs = Club.all
  end

  def create
    @borrowing = Borrowing.new(borrowing_params)
    if @borrowing.save
      redirect_to borrowings_path, notice: "Borrowing record created successfully."
    else
      render :new
    end
  end

  def edit
    @borrowing = Borrowing.find(params[:id])
  end

  def update
    @borrowing = Borrowing.find(params[:id])
    if @borrowing.update(borrowing_params)
      redirect_to borrowings_path, notice: "Borrowing record updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @borrowing = Borrowing.find(params[:id])
    if @borrowing.destroy
      redirect_to borrowings_path, notice: "Borrowing record deleted successfully."
    else
      redirect_to borrowings_path, alert: "Failed to delete borrowing record."
    end
  end

  private

  def borrowing_params
    params.require(:borrowing).permit(:equipment_id, :pic_id, :borrow_date, :due_date, :predefined_duration, :status)
  end
end
