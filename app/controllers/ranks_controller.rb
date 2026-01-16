class RanksController < ApplicationController
  def ranks
    # 
    route_ids = Helpful_mark.group(:route_id).order('count(:route_id) desc').pluck(:route_id)
    
  end
end
