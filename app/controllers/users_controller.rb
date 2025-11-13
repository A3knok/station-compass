class UsersController < ApplicationController
  before_action :set_user, only: %i[show] # 特定のユーザー情報を取得してインスタンス変数にセット

  def show;	end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
