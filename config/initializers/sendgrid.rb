if Rails.env.production?
  ActionMailer::Base.add_delivery_method :sendgrid_actionmailer, Mail::SendGridActionMailer,
    api_key: Rails.application.credentials.dig(:sendgrid, :api_key)
end
