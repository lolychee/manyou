class HomeController < ApplicationController
  def index
    @nodes_could = Topic.nodes_could
    @topics = Topic.desc(:replied_at, :created_at).paginate :per_page => 20, :page => params[:page]
  end

  def latest
    @topics = Topic.desc(:replied_at, :created_at).paginate :per_page => 20, :page => params[:page]
  end
end
