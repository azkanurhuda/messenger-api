class User < ApplicationRecord
  # encrypt password
  has_secure_password
  has_many :conversation_users
  has_many :conversations, through: :conversation_users
  has_many :messages

  validates_presence_of :email, :name

  def new_attribute
    {
      id: self.id,
      name: self.name
    }
  end
end
