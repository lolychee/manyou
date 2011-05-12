class UserSession
  #include Mongoid::Document
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor     :username, :password, :remember_me

  validates_presence_of :username
  validates_presence_of :password
  validate :password do |session|
    session.user = User.authenticate username, password
    if !session.user
      errors.add :password, 'Invalid login or password.'
    end
  end

  def self.controller=(value)
    Thread.current[:user_session_controller] = value
  end

  def controller
    Thread.current[:user_session_controller]
  end

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
    @user ||= restore_from_session || restore_from_cookie || nil if attributes == {}
  end

  def self.create(params)
    session = self.new params[:username], params[:password], params[:remember_me]
    session.save
    session
  end

  def save
    if valid?
      save_session!
      remember_me_for 4.weeks, true if @remember_me
      true
    else
      false
    end
  end

  def self.find
    self.new
  end

  def destroy
    clear_session!
    clear_remember_me_cookie!
    user.clear_persistence_token!
    user = nil
  end

  def user=(value)
    @user = value if value == nil || value.is_a?(User)
  end

  def user
    @user
  end

  def persisted?
    false
  end

  private

  def restore_from_session
    User.find(session[:current_user_id]) if session[:current_user_id]
  end

  def restore_from_cookie
    if cookies[:persistence_token]
      remember_me_for 4.weeks
      User.find(:first, :conditions => {:persistence_token => cookies[:persistence_token]})
    end
  end

  def save_session!
    session[:current_user_id] = user.id if user
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
    if user
      user.reset_persistence_token! if reset
      cookies[:persistence_token] = {
        :value => user.persistence_token,
        :expires => expires_at
      }
    end
  end

  def clear_remember_me_cookie!
    cookies.delete :persistence_token
  end



  module Implementation
    def self.included(klass)
      if defined?(::ApplicationController)
        raise
      end

      klass.prepend_before_filter :activate_controller
    end

    private
      def activate_controller
        #UserSession.controller = self
        lsession = session
        lcookies = cookies
        UserSession.send :define_method, :session, proc{ return lsession }
        UserSession.send :define_method, :cookies, proc{ return lcookies }
      end
  end

end

ActionController::Base.send(:include, UserSession::Implementation)
