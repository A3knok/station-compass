class RanksController < ApplicationController
  def index
    @station = Station.find(params[:station_id])

    # カウンターキャッシュを使って「役に立った」数で並び替え
    @routes = Route.joins(:exit).where(exits: { station_id: @station.id }).order(helpful_marks_count: :desc).limit(5)
    
  end
end
