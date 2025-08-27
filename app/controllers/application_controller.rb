class ApplicationController < ActionController::API
  def render_error(status, error_message, causes)
    render json: {
      error: error_message,
      causes: causes
    }, status: status
  end

  def render_error_message_only(status, error_message)
    render json: {
      error: error_message
    }, status: status
  end

  def render_success_no_data(message)
    render json: {
      message: message,
    }, status: :ok
  end

  def render_success(data, message)
    render json: {
      data: data,
      message: message,
    }, status: :ok
  end

  def authenticate_user
    auth_header = request.headers['Authorization']

    unless auth_header && auth_header.starts_with?('Basic ')
      render json: { message: "Authorization required" }, status: :unauthorized
      return
    end

    encoded_string = auth_header.split(' ').last
    decoded_string = Base64.decode64(encoded_string)
    user_id, password = decoded_string.split(':', 2)

    user = User.find_by(user_id: user_id)

    if user.nil?
      render_error_message_only(:not_found, "No user found")    
    elsif !user.authenticate(password)
      render_error_message_only(:unauthorized, "Authentication failed")
    else
      @current_user = user
    end
  end
end
