class Tags::TagsController < ApplicationController
  def show
    @tag = Tag.where(:name => params[:id]).first
    @topics = Topic.tagged(params[:id])
  end
end
