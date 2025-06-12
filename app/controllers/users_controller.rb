class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  skip_before_action :verify_authenticity_token
  skip_before_action :authorized, only: [ :create ]
  def new
    if authenticated?
      redirect_to root_url
    end
  end

  def me
    render json: current_user, status: :ok
  end

  def create
    puts "hello"
    user = User.new(username: params[:username])
    if user.valid?
      user.save
      @token = encode_token(user_id: user.id)
      render json: {
            user: { id: user.id, username: user.username },
            token: @token
      }, status: :created
    else
      render json: { message: "Username already in use" }, status: :unauthorized
    end
  end
end
