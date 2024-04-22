class Conversation < ApplicationRecord
  has_many :conversation_users
  has_many :users, through: :conversation_users
  has_many :chats

  def new_attribute(user)
    with_user = self.with_user(user)
    {
      id: self.id,
      with_user: {
        id: with_user.id,
        name: with_user.name,
        photo_url: with_user.photo_url
      },
      last_message: self.last_message,
      unread_count: self.unread_count(user)
    }
  end

  def read_chats(user)
    with_user = with_user(user)
    messages = Chat.where(sender_id: with_user.id, conversation_id: self.id)
    messages.update_all(is_read: true)
  end

  def last_message
    last_message = self.chats.last
    {
      id: last_message && last_message.id,
      sender: {
        id: last_message && last_message.sender.id,
        name: last_message && last_message.sender.name
      },
      message: last_message && last_message.message,
      sent_at: last_message && last_message.created_at
    }
  end

  def with_user(user)
    self.conversation_users.where.not(user_id: user).first.user
  end

  private

  def unread_count(user)
    with_user = self.with_user(user)
    self.chats.where(is_read: false).where(sender_id: with_user.id).count
  end
end
