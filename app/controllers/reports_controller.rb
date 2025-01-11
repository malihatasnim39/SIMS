class ReportsController < ApplicationController
  def index
  end

  def generate
    @super_club = Club.find(params[:super_club_id])
    @sub_club = Club.find_by(Club_ID: params[:sub_club_id])
    @start_date = params[:start_date]
    @end_date = params[:end_date]

    # Fetch expenses for the selected sub club within the date range
    @expenses = FinancialRecord.where(Club_ID: @sub_club.Club_ID)
                               .where("Created_At >= ? AND Created_At <= ?", @start_date, @end_date)

    render :generated
  end
end
