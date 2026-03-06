class RoutesController < ApplicationController
  before_action :set_station, only: %i[index]
  before_action :set_route, only: %i[ show edit update destroy ]
  before_action :check_route_owner, only: %i[ edit update destroy ]
  before_action :set_search_form_data, only: %i[ index ]
  before_action :set_new_form_data, only: %i[ new create ]
  before_action :set_edit_form_data, only: %i[ edit update ]
  skip_before_action :check_guest_user, only: %i[ index show ]


  def index
    @q = @station.routes.ransack(params[:q])
    @routes = @q.result(distinct: true).includes(:gate, :exit, :tags, :category).order(created_at: :desc)
  end

  def show
    redirect_to station_routes_path(@route), alert: "投稿が見つかりません" if @route.nil?
  end

  def new
    @route = Route.new
  end

  def edit; end

  def create
    @route = current_user.routes.build(route_params) # セッターメソッド(tag_names)呼び出し

    if @route.save
      redirect_to route_path(@route), flash: { show_thanks_modal: true } # モーダル用のflash
    else
      flash.now[:danger] = t("flash_messages.routes.create.failure")
      render :new, status: :unprocessable_entity
    end
  end

  def update
    # images以外の要素を更新
    if @route.update(route_params_without_images)

      # nilを安全に空配列として扱う
      new_images = Array(params[:route][:images]).reject(&:blank?)

      if new_images.any?
        @route.images = new_images
        @route.save
      end

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
    @station = Station.find(params[:station_id])
  end

  def check_route_owner
    redirect_to root_path unless current_user == @route.user
  end

  def set_new_form_data
    @exits = Exit.order(name: :asc)
    @stations = Station.order(name: :asc)
    @railway_companies = RailwayCompany.all.order(name: :asc)
    @companies_by_station = RailwayCompany.grouped_by_station.to_json
    @gates_by_company = Gate.grouped_by_company.to_json
    @gates = [] # フォーム用の初期値
    @categories = Category.all.order(name: :asc)
    @tags = Tag.all.order(name: :asc)
  end

  def set_edit_form_data
    @exits = Exit.order(name: :asc)
    @stations = Station.order(name: :asc)
    @railway_companies = RailwayCompany.all.order(name: :asc)
    @companies_by_station = RailwayCompany.grouped_by_station.to_json
    @gates_by_company = Gate.grouped_by_company.to_json
    @categories = Category.all.order(name: :asc)
    @tags = Tag.all.order(name: :asc)

    if @route.gate&.railway_company_id
      @gates = Gate.where(railway_company_id: @route.gate.railway_company_id)
                    .order(name: :asc)
    else
      @gates = []
    end
  end

  def set_search_form_data
    @exits = @station.exits.order(name: :asc)
    @gates = @station.gates.order(name: :asc)
    @categories = Category.all
    @tags = Tag.all
  end

  def route_params
    params.require(:route).permit(:gate_id, :exit_id, :description, :category_id, :estimated_time, :tag_names, { images: [] }, :images_cache)
  end

  def route_params_without_images
    params.require(:route).permit(:gate_id, :exit_id, :description, :category_id, :estimated_time, :tag_names)
  end
end
