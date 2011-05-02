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
  end

end
