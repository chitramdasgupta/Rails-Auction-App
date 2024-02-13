# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ActionController::HttpAuthentication::Token::ControllerMethods

  helper_method :current_user, :logged_in?, :buyer?, :seller?

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def authenticate_api_user
    authenticate_with_http_token do |token, _options|
      @current_user = User.find_by(token:)
    end
  end

  def logged_in?
    session[:user_id].present? || authenticate_api_user
  end

  def buyer?
    current_user.user_type == 'buyer'
  end

  def seller?
    current_user.user_type == 'seller'
  end
end
