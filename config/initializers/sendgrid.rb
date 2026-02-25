if Rails.env.production?
  require "sendgrid-actionmailer"

  ActionMailer::Base.add_delivery_method :sendgrid_actionmailer, Mail::SendGrid,
    api_key: Rails.application.credentials.dig(:sendgrid, :api_key)
end
