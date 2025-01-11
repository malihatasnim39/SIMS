class VendorsController < ApplicationController
  def index
    if params[:query].present?
      query = params[:query].downcase
      @vendors = Vendor.where('LOWER("Name") LIKE ?', "%#{query}%")
    else
      @vendors = Vendor.all
    end
  end

  def show
    @vendor = Vendor.find(params[:id])
  end

  def new
    @vendor = Vendor.new
  end

  def create
    @vendor = Vendor.new(vendor_params)

    if @vendor.save
      redirect_to @vendor, notice: "Vendor added successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @vendor = Vendor.find(params[:id])
  end

  def update
    @vendor = Vendor.find(params[:id])

    if @vendor.update(vendor_params)
      redirect_to @vendor, notice: "Vendor updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @vendor = Vendor.find(params[:id])
    @vendor.destroy

    redirect_to root_path, status: :see_other
  end

  private
  def vendor_params
    params.require(:vendor).permit(:Name, :Address, :Phone_Number)
  end
end
