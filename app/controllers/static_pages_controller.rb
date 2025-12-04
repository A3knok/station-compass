class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :check_guest_user

  def index; end
end
