class ApplicationController < ActionController::Base
  protect_from_forgery

  #authentication methods
  def current_user
    current_user_session.find
  end

  def current_user_session=(value)
    @user_session = value
  end

  def current_user_session
    @user_session
  end

  def authenticate_user!
  end

  #page helper methods
  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

end
