class Forum::NodesController < ApplicationController

  def index
  end

  def show
    @page_info[:list_mode] = params[:mode] || 'icon'
    @nodes = Tag.find_tags params[:id].split('+')
    @topics = Topic.find_by_tags @nodes.collect{|node| node._id }
  end

end
