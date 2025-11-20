class RoutesController < ApplicationController

  def show
    @route = current_user.routes.find(params[:id])
  end
  
  def new
    @route = Route.new
  end

  def create
    @route = current_user.routes.build(route_params)

    if @route.save
      redirect_to route_path(@route), success: t('flash_messages.routes.create.success')
    else
      flash.now[:danger] = t('flash_messages.routes.create.failure')
      render :new, status: :unprocessable_entity
    end
  end

  private

  def route_params
    params.require(:route).permit(:gate_id, :exit_id, :description, :estimated_time)
  end
end
