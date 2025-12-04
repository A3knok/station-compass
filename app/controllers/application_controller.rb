class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  add_flash_types :success, :danger

  allow_browser versions: :modern
  before_action :authenticate_user!
  before_action :check_guest_user

  private

  def check_guest_user
    if current_user&.guest?
      redirect_to routes_path, alert: "ゲストユーザーはこの操作を実行できません。"
    end
  end

end
