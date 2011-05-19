class Forum::RepliesController < ApplicationController

  before_filter :authenticate_user!

  before_filter do
    load_topic(params[:topic_id] || params[:id])
  end

  before_filter :except => [:create] do
    load_reply params[:id]
  end

  def create
    @reply = @topic.replies.new params[:topic_reply]
    @reply.floor =  @topic.replies.count + 1
    @reply.author = current_user
    if @reply.save
      @topic.replied_at = Time.now
      @topic.save
      flash[:notice] = "reply successfully."
    #else
      #render :new
    end
    redirect_to topic_path(@topic)
  end

  def destroy
    redirect_to topic_path(@topic)
  end

  def voteup
    @reply.vote!(current_user)
    redirect_to topic_path(@topic, :anchor => "reply#{@reply.floor}")
  end

  def votedown
    @reply.vote!(current_user, -1)
    redirect_to topic_path(@topic, :anchor => "reply#{@reply.floor}")
  end
end
