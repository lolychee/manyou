class Forums::TopicsController < ApplicationController

  before_filter do |controller|
    add_breadcrumb t('common.forum'), forums_path
  end
  before_filter :authenticate_user!, :except => [:index, :search, :show, :tagged]
  before_filter :load_forum, :only => [:index, :new, :create]
  before_filter :load_topic, :except => [:index, :new, :create, :tagged]

  helper_method :current_user_can_edit, :current_user_can_delete

  def load_forum
    @forum = Forum.find_by_param( params[:forum_id] || params[:id] )
    if @forum != nil
      add_breadcrumb @forum.name, forum_path(@forum)
    end
  end

  def load_tag
    @tag = Tag.find_by_param( params[:tag_id] || params[:id] )
  end

  def load_topic
    @topic = Topic.find_by_param(params[:id])
    if @topic != nil
      #add_breadcrumb @topic.forum.name, forum_path(@topic.forum)
    end
  end

  #列出主题列表
  def index
=begin
    50.times do |n|
      t = current_user.topics.create :title => "Topic #{n}", :content => "content", :tag => "tag#{n}"
      20.times do |n|
        t.replies.create :content => "content #{n}", :user => current_user
      end
    end
=end
    @topics = Topic.desc(:replied_at, :created_at).paginate :per_page => 20, :page => params[:page]
  end

  def tagged
    @topics = Topic.find_by_tags(params[:key]).all
  end

  #发表新主题表单
  def new
    @topic = Topic.new
    if @forum
      @topic_url = forum_topics_path(@forum)
    elsif @tag
      @topic_url = tag_topics_path(@tag)
    else
      @topic_url = topics_path
    end
  end

  #创建新主题
  def create
    if @forum
      @topic = @forum.topics.new params[:topic]
    elsif @tag
      @topic = @tag.topics.new params[:topic]
    else
      @topic = Topic.new params[:topic]
    end
    @topic.author = current_user
    if @topic.save
      redirect_to topic_path(@topic)
    else
      render :new
    end
  end

  #查看主题
  def show
    handle_action params[:act] if params[:act]
    @replies = @topic.replies.paginate :per_page => 20, :page => (params[:page] ||= (@topic.replies.count/20).to_i+1)
    session[:recent_read] = [] if session[:recent_read] == nil
    unless session[:recent_read].include?(@topic.id)
      @topic.on_view
      session[:recent_read] << @topic.id
    end
  end

  #编辑主题表单
  def edit
    authorize! :update, @topic
  end

  #更新主题
  def update
    authorize! :update, @topic
    @topic.on_edit
    if @topic.update_attributes params[:topic]
      redirect_to topic_path(@topic)
    else
      render :edit
    end
  end

  #删除主题
  def destroy
    redirect_to forum_path(@topic.forum)
  end

  private

  def handle_action(action)
    case action
    when 'like'
      @topic.like! current_user
    when 'unlike'
      @topic.unlike current_user
    when 'mark'
      current_user.mark! @topic
    when 'unmark'
      current_user.unmark @topic
    end
    redirect_to topic_path(@topic)
  end

end
