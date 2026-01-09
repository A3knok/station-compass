class HelpfulMarksController < ApplicationController
  before_action :set_route

  def create
    @helpful_mark = current_user.helpful_marks.build(route_id: @route.id)
    @helpful_mark.save!
    redirect_to route_path(@route)
  end

  def destroy
    @helpful_mark = current_user.helpful_marks.find_by(route_id: @route.id)
    @helpful_mark.destroy!
    redirect_to route_path(@route)
  end

  private

  def set_route
    @route = Route.find(params[:route_id])
  end
end
