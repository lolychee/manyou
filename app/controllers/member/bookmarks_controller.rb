class Member::BookmarksController < ApplicationController

  before_filter do
    path = env["PATH_INFO"].gsub(/\/bookmarks\/[add|del]/, "")

    arg = path.split '/'
    collection = arg[1]
    id = arg[2]
    case collection
    when 'topics'
      @object = load_topic(id)
    end
  end

  def index
  end

  def new
  end

  def create
    if @object && current_user.bookmarks.where(:_id => @object.id).first == nil
      @bookmark = current_user.bookmarks.new
      @bookmark.id = @object.id
      @bookmark.collection = @object.collection_name
      @bookmark.rating = params['rating'] if params['rating']
      @bookmark.desc = params['desc'] if params['desc']
      if @bookmark.save
        @object.bookmarks += 1
        @object.save
      end
      redirect_to @object
    else
      redirect_to root_path
    end
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
    if @object
      current_user.bookmarks.where(:_id => @object.id).destroy_all
      @object.bookmarks -= 1 if @object.bookmarks > 0
      @object.save
      redirect_to @object
    else
      redirect_to root_path
    end
  end
end
