class ApplicationController < ActionController::Base
  # include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :authorized

    def current_user
      token = decoded_token
      if token
        user_id = token[0]["user_id"]
        @user = User.find_by(id: user_id)
      end
    end

    def encode_token(payload)
      JWT.encode(payload, "secret_key")
    end

    def decoded_token
      header = request.headers["Authorization"]
      if header
        begin
          JWT.decode(header, "secret_key")
        rescue JWT::DecodeError
          nil
        end
      end
    end

    def authorized
      unless !!current_user
      render json: { message: "Please log in" }, status: :unauthorized
      end
    end
end
