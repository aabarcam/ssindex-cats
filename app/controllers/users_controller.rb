class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  def new
    if authenticated?
      redirect_to root_url
    end
  end

  def create
    user = User.new(username: params[:username])
    if user.valid?
      user.save
      redirect_to new_session_path
    else
      redirect_to user_path, alert: "Username already in use."
    end
  end
end
