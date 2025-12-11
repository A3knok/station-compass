class PrivacyPoliciesController < ApplicationController
  skip_before_action :check_guest_user

  def privacy_policy; end
end
