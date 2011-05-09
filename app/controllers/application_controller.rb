class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :smart_set_locale
  before_filter do |controller|
    add_breadcrumb AppConfig.app_name, root_path
  end

  helper_method :current_user, :logged_in?

  #authorization methods

  def logged_in?
    !is_guest?
  end

  def is_guest?
    current_user.is_guest?
  end

  def authenticate_user!
    redirect_to new_session_path unless logged_in?
  end

  def current_user
    @current_user ||= (login_from_session || login_from_cookie || login_as_guest)
  end

  def current_user=(user)
    if user
      save_user_session!(user)
      @current_user = user
    else
      login_as_guest
    end
  end

  def login_as_guest
    @current_user = User.new
  end

  def login_from_session
    User.find(session[:user_id]) if session[:user_id]
  end

  def login_from_cookie
    user = cookies[:persistence_token] && User.find(:first, :conditions => {:persistence_token => cookies[:persistence_token]})
    if user && user.persistence_token?
      #self.current_user = user
      #handle_remember_cookie! false # freshen cookie token (keeping date)
      user
    end
  end

  def logout
    @current_user.clear_persistence_token! if @current_user.is_a? User
    clear_remember_me_cookie!
    clear_user_session!
    login_as_guest
  end

  def remember_me
    remember_me_for 4.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    save_remember_me_cookie! time
  end

  def save_user_session!(user)
    session[:user_id] = user ? user.id : nil
  end

  def clear_user_session!
    session[:user_id] = nil
  end

  def save_remember_me_cookie!(expires_at)
    current_user.reset_persistence_token!
    cookies[:persistence_token] = {
      :value => current_user.persistence_token,
      :expires => expires_at
    }
  end

  def clear_remember_me_cookie!
    cookies.delete :persistence_token
  end

  #page helper methods

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def render_404(exception = nil)
    render_error_page(404, exception)
  end

  def render_error_page(status_code = 404, exception = nil)
    logger.info "Rendering #{code}: #{exception.message}" if exception
    status_code = status_code.to_s
    if ["404", "422", "500"].include?(status)
      render "/errors/#{status_code.to_s}", :status => status_code, :layout => 'error'
    else
      render "/errors/error", :status => status_code, :layout => 'error'
    end
  end

  def smart_set_locale
    I18n.locale = (current_user && !current_user.locale.blank? && current_user.locale) || extract_locale_from_accept_language_header || I18n.default_locale
  end

  def extract_locale_from_accept_language_header
    request.compatible_language_from(AppConfig.support_locale)
  end

  def recent_read(object)
    session[:recent_read] ||= []
    unless session[:recent_read].include?(object.id)
      session[:recent_read] << object.id
      object.hits += 1
      object.save
    end
  end

  #resrouce load helper
  def load_user(username)
    @user = User.where(:username => /username/i).first || render_404
  end

  def load_topic(id)
    @topic = Topic.where(:nid => id).first || render_404
  end

  def load_reply(id)
    @reply = @topic.replies.find id || render_404
  end

  def load_tags(key)
    @tags = Tag.find_by_tags key || render_404
  end

end
