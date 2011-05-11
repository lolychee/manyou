class UserSession
  #include Mongoid::Document
  include ActiveModel::Validations

  attr_accessor     :username, :password, :remember_me

  def self.controller=(value)
    Thread.current[:user_session_controller] = value
  end

  def controller
    Thread.current[:user_session_controller]
  end

  def initialize(username = nil, password = nil, remember_me = false)
    @username, @password, @remember_me = username, password, remember_me
  end

  def self.create(params)
    session = self.new params[:username], params[:password], params[:remember_me]
    session.save
  end

  def save
    @user = User.authenticate @username, @password
    if @user
      save_session!
      remember_me_for 4.weeks, true if @remember_me
      @user
    end
  end

  def find
    @user ||= restore_from_session || restore_from_cookie || false if @user != false
  end

  def destroy
    clear_session!
    clear_remember_me_cookie!
    @user.clear_persistence_token!
    @user = false
  end

  private

  def cookies
    controller.send :cookies
  end

  def session
    controller.send :session
  end

  def restore_from_session
    User.find(session[:current_user_id]) if session[:current_user_id]
  end

  def restore_from_cookie
    if cookies[:persistence_token]
      User.find(:first, :conditions => {:persistence_token => cookies[:persistence_token]})
      remember_me_for 4.weeks
    end
  end

  def save_session!
    session[:current_user_id] = @user.id if @user
  end

  def clear_session!
    session[:current_user_id] = nil
  end

  def remember_me_for(time, reset = false)
    remember_me_until time.from_now.utc, reset
  end

  def remember_me_until(time,reset = false)
    save_remember_me_cookie! time
  end

  def save_remember_me_cookie!(expires_at, reset = false)
    @user.reset_persistence_token! if reset
    cookies[:persistence_token] = {
      :value => @user.persistence_token,
      :expires => expires_at
    }
  end

  def clear_remember_me_cookie!
    cookies.delete :persistence_token
  end



  module Implementation
    def self.included(klass) # :nodoc:
      if defined?(::ApplicationController)
        raise
      end

      klass.prepend_before_filter :activate_controller
    end

    private
      def activate_controller
        UserSession.controller = self
      end
  end

end

ActionController::Base.send(:include, UserSession::Implementation)
