class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user, :current_user_session, :signed_in?

  before_filter :smart_set_locale

  before_filter do
    @page_info = {}
  end

  #authentication methods
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  def signed_in?
    !!current_user
  end

  def authenticate_user!
    redirect_to new_session_path unless signed_in?
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

  #load rescources methods
  def load_user(username)
    @user = User.first(:conditions => { :username => /#{username}/i }) || render_404
  end

  def load_topic(id)
    @topic = Topic.first(:conditions => { :_id => id.to_i}) || render_404
  end

  def load_reply(id)
    @reply = @topic.replies.find id || render_404
  end

  def load_tag(tag)
      @tag = Tag.find_by_tag tag
  end

  def load_tags(arr)
  end

end
