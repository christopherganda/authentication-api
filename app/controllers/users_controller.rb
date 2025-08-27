class UsersController < ApplicationController
  before_action :authenticate_user, only: [:show, :update, :destroy]
  before_action :check_user_id_match, only: [:show, :update, :destroy]
  before_action :update_params_check, only: [:update]
  skip_before_action :authenticate_user, only: [:create]

  def create
    user = User.new(user_params)
    if user.save
      render_success(user_response(user), "Account successfully created")
    else
      render_error(:bad_request, "Account creation failed", build_error_message(user.errors.messages))
    end
  end

  def show
    render_success(user_response_show(@current_user), "User details by user_id")
  end

  def update
    @current_user.comment = user_params[:comment] if user_params[:comment]
    @current_user.nickname = user_params[:nickname] if user_params[:nickname]
    if @current_user.save
      render_success(user_response(@current_user), "User successfully updated")
    else
      render_error(:bad_request, "User updation failed", build_update_error_message(@current_user.errors.messages))
    end
  end

  def destroy
    @current_user&.destroy
    render_success_no_data("Account and user successfully removed")
  end

  private

  def check_user_id_match
    unless @current_user.user_id == params[:user]
      render_error_message_only(:forbidden, "No permission for update")
    end
  end

  def user_response(user)
    { user_id: user.user_id, nickname: user.nickname }
  end

  def user_response_show(user)
    nickname = user.nickname.nil? || user.nickname.empty? ? user.user_id : user.nickname
    if user.comment.nil? || user.comment.empty?
      user_response(user)
    else
      user_response_with_comment(user)
    end
  end

  def user_response_with_comment(user)
    { user_id: user.user_id, nickname: user.nickname, comment: user.comment }
  end

  def user_params
    params.permit(:user_id, :password, :nickname, :comment)
  end

  def update_params_check
    if user_params[:user_id] || user_params[:password]
      render_error(:bad_request, "User updation failed", "Not updatable user_id and password")
      return
    elsif user_params[:nickname].nil? && user_params[:comment].nil?
      render_error(:bad_request, "User updation failed", "Required nickname or comment")
      return
    end
  end

  def build_error_message(errors)
    return "Invalid parameters" unless errors.is_a?(Hash)

    if errors[:user_id]&.include?("has already been taken")
      "Already same user_id is used"
    elsif errors[:user_id]&.any? && errors[:password]&.any?
      "Required user_id and password"
    elsif errors[:user_id]&.any? && errors[:user_id]&.include?("is too short (minimum is 6 characters)") || errors[:user_id]&.include?("is too long (maximum is 20 characters)")
      "Input length is incorrect"
    elsif errors[:user_id]&.any? && errors[:user_id]&.include?("Incorrect character pattern")
      "Incorrect character pattern"
    
    elsif errors[:password]&.any? && errors[:password]&.include?("is too short (minimum is 8 characters)") || errors[:password]&.include?("is too long (maximum is 20 characters)")
      "Input length is incorrect"
    elsif errors[:password]&.any? && errors[:password]&.include?("Incorrect character pattern")
      "Incorrect character pattern"
    elsif errors[:user_id]&.any? || errors[:password]&.any?
      "Required user_id and password"
    else
      "Unknown error"
    end
  end

  def build_update_error_message(errors)
    return "Invalid parameters" unless errors.is_a?(Hash)

    puts errors
    if errors[:nickname]&.any? || errors[:comment]&.any?
      "string length is invalid"
    end
  end
end