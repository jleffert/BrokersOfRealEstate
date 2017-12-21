class ContactMailer < ApplicationMailer
  def contact_email(email:, message:)
    @email = email 
    @message = message

    mail to: "jleffert9@gmail.com",
         subject: "Website Contact Form From: #{@email}",
         content_type: 'text/html'
  end
end
