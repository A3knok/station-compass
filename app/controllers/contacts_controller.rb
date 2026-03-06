class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = current_user.contacts.build(contact_params)

    Rails.logger.debug "=== Before Save ==="
    Rails.logger.debug "@contact.valid?: #{@contact.valid?}"
    Rails.logger.debug "@contact.errors: #{@contact.errors.full_messages}"
    Rails.logger.debug "==================="

    if @contact.save
      ContactMailer.contact_mail(@contact).deliver_now # 非同期でメール送信
      redirect_to root_path, success: t("flash_messages.contacts.create.success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:subject, :body)
  end
end
