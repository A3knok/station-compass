class ContactMailer < ApplicationMailer
  def contact_mail(contact)
    @contact = contact
    @user = contact.user
    mail(
      to: @user.email,
      bcc: Settings.action_mailer.bcc,
      subject: "【自動送信】お問い合わせを受け付けました｜#{@contact.subject}"
    )
  end
end
