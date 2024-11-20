class FinancialRecordsController < ApplicationController
  def expenseForm
    @financial_record = FinancialRecord.new
  end

  def expenseDashboard
    @financial_records = FinancialRecord.includes(:equipment, :club).order(Created_At: :desc)
  end

  def create
    @financial_record = FinancialRecord.new(financial_record_params)

    if @financial_record.save
      redirect_to root_path
    else
      render :expenseForm
    end
  end

  def financial_record_params
    params.require(:financial_record).permit(:Title, :Amount, :Vendor_ID, :Equipment_ID, :Quantity, :Club_ID)
  end
end
