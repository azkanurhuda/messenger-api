class Chat < ApplicationRecord
  belongs_to :sender, class_name: "User", foreign_key: "sender_id"
  belongs_to :conversation
  belongs_to :parent, class_name: "Chat", optional: true

  validates_presence_of :sender_id, :conversation_id, :message

  def created_attribute(user)
    with_user = self.conversation.with_user(user)
    {
      id: self.id,
      message: self.message,
      reply_to: self.reply_to_attribute,
      sender: self.sender.new_attribute,
      sent_at: self.created_at,
      conversation: {
        id: self.conversation.id,
        with_user: {
          id: with_user.id,
          name: with_user.name,
          photo_url: with_user.photo_url
        }
      }
    }
  end

  def new_attribute
    {
      id: self.id,
      message: self.message,
      reply_to: self.reply_to_attribute,
      sender: self.sender.new_attribute,
      sent_at: self.created_at,
    }
  end

  def reply_to_attribute
    parent = self.parent
    parent && {
      id: parent.id,
      sender: parent.sender.new_attribute,
      message: parent.message,
      sent_at: parent.created_at
    }
  end

  def self.new_message(sender, receiver, message, reply_to)
    @conversation = (sender.conversations & receiver.conversations).first
    if @conversation.nil?
      @conversation = Conversation.new
      @conversation.users << sender
      @conversation.users << receiver
      @conversation.save
    end
    @chat = Chat.new
    @chat.conversation = @conversation
    @chat.message = message
    @chat.sender = sender
    @chat.parent = reply_to unless reply_to.nil? || @conversation != reply_to.conversation
    return @chat
  end
end