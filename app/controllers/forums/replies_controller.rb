class Forums::RepliesController < ApplicationController

  before_filter :authenticate_user!, :except => [:show]

  before_filter :load_topic, :only => [:create, :argee]
  before_filter :load_reply, :except => [:create]

  def load_topic
    @topic = Topic.find_by_param(params[:topic_id] || params[:id])
  end

  def load_reply
    @reply = @topic.replies.find params[:id]
  end

  def create
    @reply = @topic.replies.new params[:reply]
    @reply.floor =  @topic.replies.count + 1
    @reply.author = current_user
    if @reply.save
      flash[:notice] = "Reply successfully."
      @topic.on_reply
      redirect_to topic_path(@topic)
    else
      render :new
    end
  end

  def agree
    @reply.on_argee
    flash[:notice] = "vote successfully."
    redirect_to topic_path(@topic)
  end

  def down
  end

  def destroy
  end

end
