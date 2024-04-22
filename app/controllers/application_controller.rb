class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler

  before_action :authorize_user


  private

  def authorize_user
    @user = AuthorizeApiRequest.new(request.headers).call[:user]
  end
end
