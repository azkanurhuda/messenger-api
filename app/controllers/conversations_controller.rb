class ConversationsController < ApplicationController
  before_action :set_conversation, only: [:show, :show_chats]
  def index
    @conversations = @user.conversations
    return render json: {
      data: @conversations.map { |conversation| conversation.new_attribute(@user)}
    }, status: :ok
  end

  def show
    return render json: {
      data: @conversation.new_attribute(@user)
    }, status: :ok
  end

  def show_chats
    @conversation.read_chats(@user)
    return render json: {
      data: @conversation.chats.map{ |chat| chat.new_attribute}
    }, status: :ok
  end

  private

  def set_conversation
    @conversation = Conversation.find_by_id(params[:id] || params[:conversation_id])
    if @conversation.nil?
      return render json: {
        message: "Conversation not found"
      }, status: :not_found
    end

    if @conversation.conversation_users.exists?(user_id: @user.id) == false
      return render json: {
        message: "you can not open other user's conversation"
      }, status: :forbidden
    end
  end
end
