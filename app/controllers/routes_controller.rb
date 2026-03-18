class RoutesController < ApplicationController
  before_action :set_station, only: %i[index]
  before_action :set_route, only: %i[ show edit update destroy ]
  before_action :set_form_data, only: %i[ new edit create update ]
  before_action :check_route_owner, only: %i[ edit update destroy ]
  before_action :set_search_form_data, only: %i[ index ]
  skip_before_action :check_guest_user, only: %i[ index show ]

  def index
    @q = @station.routes.ransack(params[:q])
    @routes = @q.result(distinct: true).includes(:gate, :exit, :tags, :category).order(created_at: :desc)
  end

  def show; end

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
    # 画像を更新するための処理
    @route.update_images(params[:route][:images])

    if @route.update(route_params_without_images)
      redirect_to route_path(@route), success: t("flash_messages.routes.update.success")
    else
      flash.now[:danger] = t("flash_messages.routes.update.failure")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @route.destroy
      redirect_to user_path(current_user), success: t("flash_messages.routes.destroy.success")
    else
      redirect_to route_path(@route), alert: t("flash_messages.routes.destroy.failure")
    end
  end

  private

  def set_route
    @route = Route.includes(:station, :gate, :exit).find(params[:id])
  end

  def set_station
    @station = Station.find(params[:station_id])
  end

  def set_form_data
    # 共通のフォームデータ
    @exits = Exit.order(name: :asc)
    @stations = Station.order(name: :asc)
    @railway_companies = RailwayCompany.all.order(name: :asc)
    @companies_by_station = RailwayCompany.grouped_by_station.to_json
    @gates_by_company = Gate.grouped_by_company.to_json
    @categories = Category.all.order(name: :asc)
    @tags = Tag.all.order(name: :asc)

    # 編集時のみ、既存のゲートを設定
    if @route&.gate&.railway_company_id
      @gates = Gate.where(railway_company_id: @route.gate.railway_company_id)
                    .order(name: :asc)
    else
      @gates = [] # new アクション用の初期値
    end
  end

  def set_search_form_data
    @exits = @station.exits.order(name: :asc)
    @gates = @station.gates.order(name: :asc)
    @categories = Category.all
    @tags = Tag.all
  end

  def check_route_owner
    redirect_to root_path unless current_user == @route.user
  end

  def route_params
    params.require(:route).permit(
      :gate_id, :exit_id, :description, :category_id,
      :estimated_time, :tag_names, :images_cache,
      images: []
    )
  end

  def route_params_without_images
    params.require(:route).permit(
      :gate_id, :exit_id, :description, :category_id,
      :estimated_time, :tag_names)
  end
end
