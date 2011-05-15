class Forum::TopicsController < ApplicationController

  before_filter :authenticate_user!, :except => [:index, :show, :tagged]

  before_filter :except => [:index, :new, :create, :tagged] do
    load_topic(params[:id])
    #add_breadcrumb 'topics', topics_path
    #add_breadcrumb @topic.title, topic_path(@topic)
  end

  def index
    @page_info[:list_mode] = params[:mode] || 'icon'
    @topics = Topic.desc(:replied_at, :created_at).paginate :per_page => 20, :page => params[:page]
  end

  def new
    #authorize! :create, @topic
    @topic = Topic.new
    @topic.type = params[:type] if params[:type] && Topic::TYPE.include?(params[:type])
  end

  def create
    #authorize! :create, @topic
    @topic = Topic.new params[:topic]
    @topic.author = current_user
    if @topic.save
      redirect_to topic_path(@topic)
    else
      render :new
    end
  end

  def show
    @replies = @topic.replies.paginate :per_page => 20, :page => (params[:page] ||= (@topic.replies.count/20).to_i+1)
    recent_read @topic
  end

  def edit
    authorize! :update, @topic
  end

  def update
    authorize! :update, @topic
    @topic.edited_at = Time.now
    if @topic.update_attributes params[:topic]
      redirect_to topic_path(@topic)
    else
      render :edit
    end
  end

  def destroy
    redirect_to topics_path
  end

end
