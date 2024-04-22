class ChatsController < ApplicationController

  def create
    sender = @user
    message = params[:message]
    receiver = User.find_by_id(params[:user_id])
    reply_to = Chat.find_by_id(params[:reply_to_id])
    if message.blank?
      return render json: {
        message: "can not send empty message"
      }, status: :unprocessable_entity
    end
    if receiver.nil?
      return render json: {
        message: "receiver did not exist"
      }, status: :unprocessable_entity
    end

    @chat = Chat.new_message(sender, receiver, message, reply_to)

    if @chat.save
      return render json: {
        data: @chat.created_attribute(@user)
      }, status: :created
    else
      return render json: @chat.errors, status: :unprocessable_entity
    end
  end
end
