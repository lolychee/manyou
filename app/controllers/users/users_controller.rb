class Users::UsersController < ApplicationController

  before_filter :load_user, :except => [:index, :new, :create]

  def load_user
    @user = User.find_by_param(params[:id])
    add_breadcrumb 'user', users_path()
    add_breadcrumb @user.name, user_path(@user)
  end

  def index
  end

  def show
    handle_action params[:act] if params[:act]
  end

  private

  def handle_action(action)
    case action
    when 'follow'
      current_user.add_follow @user
    when 'unfollow'
      current_user.del_follow @user
    end
    redirect_to user_path(@user)
  end

end
