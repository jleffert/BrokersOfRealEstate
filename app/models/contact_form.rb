class ContactForm
  include ActiveModel::Model

  attr_accessor :email, :message

  validates :email, :message, presence: true
  validates_format_of :email,:with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  
end