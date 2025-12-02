class RoutesController < ApplicationController
  before_action :set_route, only: %i[ show edit update destroy ]
  before_action :check_route_owner, only: %i[ edit update destroy ]
  before_action :set_search_form_data, only: %i[ index ]
  before_action :set_new_form_data, only: %i[ new create edit update ]


  def index
    @q = Route.ransack(params[:q])
    @routes = @q.result(distinct: true).includes(:gate, :exit).order(created_at: :desc)
  end

  def show
    return redirect_to routes_path, alert: '投稿が見つかりません' if @route.nil?
  end

  def new
    @route = Route.new
  end

  def edit; end

  def create
    @route = current_user.routes.build(route_params)

    if @route.save
      redirect_to route_path(@route), success: t("flash_messages.routes.create.success")
    else
      flash.now[:danger] = t("flash_messages.routes.create.failure")
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @route.update(route_params)
      redirect_to route_path(@route), success: t("flash_messages.routes.update.success")
    else
      flash.now[:danger] = t("flash_messages.routes.update.failure")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @route.destroy!
    redirect_to user_path(current_user)
  end

  private

  def set_route
    @route = Route.find_by(id: params[:id])
  end

  def check_route_owner
    redirect_to root_path unless current_user == @route.user
  end

  def set_new_form_data
    @exits = Exit.all
    @railway_companies = RailwayCompany.all.order(:name)
    @gates_by_company = Gate.grouped_by_company.to_json
    @gates = []
  end

  def set_search_form_data
    @exits = Exit.all
    @gates = Gate.all
  end

  def route_params
    params.require(:route).permit(:gate_id, :exit_id, :description, :estimated_time)
  end
end
