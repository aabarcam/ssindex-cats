class SessionsController < ApplicationController
  # allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }
  protect_from_forgery with: :null_session
  skip_before_action :authorized, only: [ :new, :create ]

  # unused
  def new
  end

  def create
    if @user = User.find_by(username: params[:username]) # auth
      @token = encode_token(user_id: @user.id)
      render json: {
                user: { id: @user.id, username: @user.username },
                token: @token
            }, status: :accepted
    else
      render json: { message: "Username not registered" }, status: :unauthorized
    end
  end

  # not used
  def destroy
    terminate_session
    redirect_to new_session_path
  end
end
