class EquipmentsController < ApplicationController
  def index
    @equipments = Equipment.all
    @equipment = Equipment
  end

  def new
    @equipment = Equipment.new
  end

  def create
    @equipment = Equipment.new(equipment_params)

    if @equipment_create.save
      redirect_to @equipment, notice: "Equipment added successfully!"
    else
      render :index, status: :unprocessable_entity
    end
  end

  private
    def equipment_params
      params.require(:equipment).permit(:Equipment_Name, :Financial_Record_Id, :Club_ID, :Vendor_ID)
    end
end