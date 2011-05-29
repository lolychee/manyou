class Forum::NodesController < ApplicationController

  before_filter :except => [:index, :new, :create] do
    @node = load_node(params[:id])
  end

  def index
    @nodes_could = Topic.nodes_could
    @topics = Topic.desc(:replied_at, :created_at).paginate :per_page => 20, :page => params[:page]
  end

=begin
  def tagged
    @keys = Tag.find_tags params[:key].split('+')
    @topics = Topic.where(:tag_ids.in => @nodes.collect{|node| node._id }).and(:tag_ids.all => @keys.collect{|key| key._id }).desc(:replied_at, :created_at).paginate :per_page => 20, :page => params[:page]
    render :show
  end
=end

  def new
    @node = Node.new
  end

  def create
    @node = Node.new params[:node]
    if @node.save
      redirect_to node_path(@node)
    else
      render :new
    end
  end

  def show
    @topics = @node.topics.desc(:replied_at, :created_at).paginate :per_page => 20, :page => params[:page]
  end

  def edit
  end

  def update
    if @node.update_attributes params[:node]
      redirect_to node_path(@node)
    else
      render :edit
    end
  end

end
