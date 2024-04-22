class UsersController < ApplicationController
  skip_before_action :authorize_user

  def login
    user = AuthenticateUser.new(params[:email], params[:password])
    if user
      return render json: {
        token: user.call
      }, status: :ok
    end
  end

  def sign_up
    @user = User.new(sign_up_params)
    if @user.save
      return render json: @user.new_attribute, status: :created
    else
      return render json: @user.errors.full_messages, status: :bad_request
    end
  end

  private

  def sign_up_params
    {
      email: params[:email],
      name: params[:name],
      password: params[:password]
    }
  end
end
