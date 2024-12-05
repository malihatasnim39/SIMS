class FinancialRecordsController < ApplicationController
  def expenseForm
    @financial_record = FinancialRecord.new
  end

  def expenseDashboard
    sort_column = case params[:sort]
    when "amount_asc" then '"Amount" ASC'
    when "amount_desc" then '"Amount" DESC'
    when "date_asc" then '"Created_At" ASC'
    when "date_desc" then '"Created_At" DESC'
    else '"Created_At" DESC' # Default sorting
    end

    @financial_records = FinancialRecord.includes(:equipment, :club).order(Arel.sql(sort_column))
  end

  def expense_details
    @financial_record = FinancialRecord.includes(:club, :equipment, :vendor).find(params[:id])
  end

  def create
    @financial_record = FinancialRecord.new(financial_record_params)

    if @financial_record.save
      redirect_to root_path
    else
      render :expenseForm
    end
  end

  def edit
    @financial_record = FinancialRecord.find(params[:id])
  end

  def update
    @financial_record = FinancialRecord.find(params[:id])
    if @financial_record.update(financial_record_params)
      redirect_to expense_details_financial_record_path(@financial_record)
    else
      render :editExpense
    end
  end

  def destroy
    @financial_record = FinancialRecord.find(params[:id])
    if @financial_record.destroy
      redirect_to expenseDashboard_financial_records_path
    else
      redirect_back(fallback_location: expense_details_financial_record_path(@financial_record))
    end
  end
  def super_club_expenses
    # Fetch financial records for super clubs
    @super_club_expenses = FinancialRecord.joins(:club)
                                          .where(clubs: { Is_Super_Club: true })
                                          .group("clubs.Club_Name")
                                          .select('clubs."Club_Name", SUM("Amount") AS total_expenses')
     @total_super_club_expenses = @super_club_expenses.sum(&:total_expenses)
  end

  def super_club_expenses
    @super_clubs = Club.where(Is_Super_Club: true)
    @super_club_expenses = {}

    @super_clubs.each do |club|
      club_expenses = FinancialRecord.where(club_id: financial_record.Club_ID).sum(:Amount)
      @super_club_expenses[club.club_name] = club_expenses
    end

    @total_super_club_expenses = @super_club_expenses.values.sum
  end

  def delete_confirmation
    @financial_record = FinancialRecord.find(params[:id])
  end

  def financial_record_params
    params.require(:financial_record).permit(:Title, :Amount, :Vendor_ID, :Equipment_ID, :Quantity, :Club_ID)
  end
end
