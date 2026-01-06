class RoutesController < ApplicationController
  before_action :set_route, only: %i[ show edit update destroy ]
  before_action :set_station
  before_action :check_route_owner, only: %i[ edit update destroy ]
  before_action :set_search_form_data, only: %i[ index ]
  before_action :set_new_form_data, only: %i[ new create edit update ]
  before_action :set_edit_form_data, only: %i[ edit update ]
  skip_before_action :check_guest_user, only: %i[ index show ]


  def index
    @q = Route.ransack(params[:q])
    @routes = @q.result(distinct: true).includes(:gate, :exit).order(created_at: :desc)
  end

  def show
    redirect_to routes_path, alert: "投稿が見つかりません" if @route.nil?
  end

  def new
    @route = Route.new
  end

  def edit; end

  def create
    @route = current_user.routes.build(route_params)

    if @route.save
      redirect_to route_path(@route), flash: { show_thanks_modal: true } # モーダル用のflash
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

  def set_station
    @station = Station.find_by(name: "渋谷駅")
  end

  def check_route_owner
    redirect_to root_path unless current_user == @route.user
  end

  def set_new_form_data
    @exits = Exit.order(name: :asc)
    @railway_companies = RailwayCompany.all.order(name: :asc)
    @gates_by_company = Gate.grouped_by_company.to_json
    @gates = []
    @categories = Category.all.order(name: :asc)
  end

  def set_edit_form_data
    @exits = Exit.order(name: :asc)
    @railway_companies = RailwayCompany.all.order(name: :asc)
    @gates_by_company = Gate.grouped_by_company.to_json

    if @route.gate&.railway_company_id
      @gates = Gate.where(railway_company_id: @route.gate.railway_company_id)
                    .order(name: :asc)
    else
      @gates = []
    end
  end

  def set_search_form_data
    @exits = Exit.order(name: :asc)
    @gates = Gate.order(name: :asc)
  end

  def route_params
    params.require(:route).permit(:gate_id, :exit_id, :description,:category_id, :estimated_time)
  end
end
