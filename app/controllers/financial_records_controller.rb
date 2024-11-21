class FinancialRecordsController < ApplicationController
  def expenseForm
    @financial_record = FinancialRecord.new
  end

  def expenseDashboard
    @financial_records = FinancialRecord.includes(:equipment, :club).order(Created_At: :desc)
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

  def delete_confirmation
    @financial_record = FinancialRecord.find(params[:id])
  end

  def financial_record_params
    params.require(:financial_record).permit(:Title, :Amount, :Vendor_ID, :Equipment_ID, :Quantity, :Club_ID)
  end
end
