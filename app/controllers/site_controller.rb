class SiteController < ApplicationController
  def index
  end

  def contact_us
    @contact_form = ContactForm.new
  end

  def send_contact_form
    @contact_form = ContactForm.new(contact_form_params)

    if @contact_form.valid?
      ContactMailer.contact_email(email: @contact_form.email, message: @contact_form.message).deliver

      flash[:success] = 'Contact form sent!'
      @contact_form = ContactForm.new

      render :contact_us
    else
      render :contact_us
    end
  end

  private
  def contact_form_params
    params.require(:contact_form).permit(:email, :message)
  end
end