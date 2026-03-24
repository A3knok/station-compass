class HelpfulMarksController < ApplicationController
  before_action :set_route
  skip_before_action :check_guest_user, only: %i[ create destroy ]

  def create
    current_user.mark_as_helpful(@route)
  end

  def destroy
    current_user.unmark_as_helpful(@route)
  end

  private

  def set_route
    @route = Route.find(params[:route_id])
  end
end
