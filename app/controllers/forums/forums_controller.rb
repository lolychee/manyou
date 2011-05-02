class Forums::ForumsController < ApplicationController

  before_filter do |controller|
    add_breadcrumb t('common.forum'), forums_path
  end
  before_filter :load_forum, :except => [:index, :new, :create]
  before_filter :authenticate_user!, :except => [:index, :show]

  def load_forum
    @forum = Forum.find_by_param( params[:forum_id] || params[:id] )
    add_breadcrumb @forum.name, forum_path(@forum)
  end

  def index
    @forums = Forum.all
    @tagcould = Topic.where(:created_at => {'$lt' => Time.now.prev_month}).tag_could.find()#.sort({:value => -1})
    @topics = Topic.desc(:replied_at, :created_at).paginate :per_page => 20, :page => params[:page]
  end

  def new
    @forum = Forum.new
  end

  def create
    @forum = Forum.new params[:forum]
    if @forum.save
      redirect_to forum_path(@forum)
    else
      render :new
    end
  end

  def show
    @topics = Topic.find_by_forum(@forum.id).desc(:replied_at, :created_at).paginate :per_page => 20, :page => params[:page]
  end

  def edit
    authorize! :update, @forum
  end

  def update
    authorize! :update, @forum
    if @forum.update_attributes params[:forum]
      redirect_to topic_path(@forum)
    else
      render :edit
    end
  end

  def destroy
  end

end
