class StationsController < ApplicationController
  skip_before_action :check_guest_user, only: %i[ index ]

  def index
    @stations = Station.all
  end
end
