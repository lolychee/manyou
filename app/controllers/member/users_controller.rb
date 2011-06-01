class Member::UsersController < ApplicationController

  before_filter do
    @user = load_user(params[:id])
    add_breadcrumb t('breadcrumbs.users'), users_path
  end

  def show
  end

  def follow
  end

  def unfollow
  end

end
