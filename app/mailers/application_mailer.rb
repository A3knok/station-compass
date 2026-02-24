class ApplicationMailer < ActionMailer::Base
  default from: ENV["GMAIL_USERNAME"] || "test@example.com"
  layout "mailer"
end
