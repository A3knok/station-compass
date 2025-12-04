class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters
  skip_before_action :authenticate_user!, only: %i[new create]
  skip_before_action :check_guest_user, only: %i[new, create]

  def after_sign_up_path_for(resource)
    user_path(resource)
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])
  end
end
