class Contact < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :first_name, presence:true
  validates :last_name, presence:true
  validates :email, uniqueness:true
  validates :email, format: { with: VALID_EMAIL_REGEX,
    message: "Incorrect format use example@service.com" }
    
  def full_name
    "#{first_name} #{last_name}".titleize
  end
  def friendly_phone_number
    "+ 81 #{phone_number}"
  end
  def friendly_updated_at
    updated_at.strftime("%b %d, %Y")
  end
  def as_json
    {
      id:id,
      first_name:first_name,
      middle_name:middle_name,
      last_name:last_name,
      email:email,
      phone_number:friendly_phone_number,
      full_name:full_name,
      bio: bio,
      updated_at:friendly_updated_at
    }
  end 
end
