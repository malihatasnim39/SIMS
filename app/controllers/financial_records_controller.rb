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
    # Fetch all super clubs
    @super_clubs = Club.where(Is_Super_Club: true)
    @super_club_expenses = {}

    # Calculate total expenses for each super club
    @super_clubs.each do |super_club|
      # Fetch all sub-club IDs belonging to this super club
      sub_club_ids = Club.where(Parent_Club: super_club.Club_ID).pluck(:Club_ID)

      # Sum expenses for these sub-clubs
      club_expenses = FinancialRecord.where(Club_ID: sub_club_ids).sum(:Amount)

      # Store the total expenses in a hash with the super club's name
      @super_club_expenses[super_club.Club_Name] = club_expenses
    end

    # Calculate the total expenses for all super clubs combined
    @total_super_club_expenses = @super_club_expenses.values.sum
  end

  def all_super_expenses
    @club = Club.find(params[:id]) # Find the super club using the passed ID
    sub_club_ids = Club.where(Parent_Club: @club.Club_ID).pluck(:Club_ID) # Fetch IDs of sub-clubs
    # Fetch financial records tied to those sub-clubs
    @expenses = FinancialRecord.where(Club_ID: sub_club_ids)
  end

  def sub_club_expenses
    # Fetch all sub-clubs (those with Parent_Club not null and Is_Super_Club is false)
    @sub_clubs = Club.where(Is_Super_Club: false).where.not(Parent_Club: nil)
    @sub_club_expenses = {}

    # Calculate total expenses for each sub-club
    @sub_clubs.each do |sub_club|
      # Sum expenses for the sub-club
      club_expenses = FinancialRecord.where(Club_ID: sub_club.Club_ID).sum(:Amount)

      # Store the total expenses in a hash with the sub-club's name
      @sub_club_expenses[sub_club.Club_Name] = club_expenses
    end

    # Calculate the total expenses for all sub-clubs combined
    @total_sub_club_expenses = @sub_club_expenses.values.sum
  end

  def all_sub_expenses
    @club = Club.find(params[:id])  # Find the sub-club using the passed ID
    @expenses = FinancialRecord.joins(:club, :vendor)  # Ensure we join with both club and vendor
                               .where('"financial_records"."Club_ID" = ?', @club.Club_ID)  # Match the Club_ID
  end


  def delete_confirmation
    @financial_record = FinancialRecord.find(params[:id])
  end

  def financial_record_params
    params.require(:financial_record).permit(:Title, :Amount, :Vendor_ID, :Equipment_ID, :Quantity, :Club_ID)
  end
end
