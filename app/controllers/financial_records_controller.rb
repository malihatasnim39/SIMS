class FinancialRecordsController < ApplicationController
  def expenseForm
    @financial_record = FinancialRecord.new
  end

  def create
    @financial_record = FinancialRecord.new(financial_record_params)

    if @financial_record.save
      flash[:notice] = "Financial record created successfully!"
      redirect_to root_path
    else
      flash.now[:alert] = "Error creating financial record."
      render :new
    end
  end

  def financial_record_params
    params.require(:financial_record).permit(:Title, :Amount, :Vendor_ID, :Equipment_ID, :Quantity)
  end
end
