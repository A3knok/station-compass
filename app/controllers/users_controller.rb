class UsersController < ApplicationController
  before_action :set_user, only: %i[show] # 特定のユーザー情報を取得してインスタンス変数にセット
  before_action :check_owner, only: %i[show]

  def show
    @recent_routes = @user.routes.includes(:gate, :exit)
                    .limit(5)
                    .order(created_at: :desc)
    @total_routes_count = @user.routes.count
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def check_owner
    redirect_to root_path unless current_user == @user
  end
end
