class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :validatable, :trackable, :lockable
  validates :username, uniqueness: true

  def email_required?
    false
  end

  def email_changed?
    false
  end
  
end
