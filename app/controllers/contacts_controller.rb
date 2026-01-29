class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)

    if @contact.save
      Contact.contact_mail(@contact).deliver_later #非同期でメール送信
      redirect_to root_path, success: t("flash_messages.contacts.create.success")
    else
      render :new
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:subject, :body)
  end
end
