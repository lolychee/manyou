class Forum::NodesController < ApplicationController

  before_filter do
    @page_info[:list_mode] = params[:mode] || 'summary'
    @nodes = Node.find_nodes params[:id].split('+') if params[:id]
    @node = @nodes.first if @nodes != nil
  end

  def index
    @topics = Topic.paginate :per_page => 20, :page => params[:page]
    render :show
  end

=begin
  def tagged
    @keys = Tag.find_tags params[:key].split('+')
    @topics = Topic.where(:tag_ids.in => @nodes.collect{|node| node._id }).and(:tag_ids.all => @keys.collect{|key| key._id }).desc(:replied_at, :created_at).paginate :per_page => 20, :page => params[:page]
    render :show
  end
=end

  def show
    @topics = Topic.find_by_nodes(@nodes.collect{|node| node._id }).desc(:replied_at, :created_at).paginate :per_page => 20, :page => params[:page]
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
