class Member::UsersController < ApplicationController

  before_filter do
    @user = load_user(params[:id])
  end

  def show
  end

  def follow
  end

  def unfollow
  end

end
