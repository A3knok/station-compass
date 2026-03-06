class PagesController < ApplicationController
  skip_before_action :check_guest_user
  skip_before_action :authenticate_user!

  def privacy_policy; end
  def terms; end
end
