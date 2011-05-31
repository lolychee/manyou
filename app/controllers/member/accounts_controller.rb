class Member::AccountsController < ApplicationController

  before_filter :except => [:new, :create] do
    @user = current_user
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new params[:user]
    if @user.save
      current_user = @user
      redirect_to root_url
    else
      render :new
    end
  end

  def edit
  end

  def update
    if params[:user] && @user.update_attributes(params[:user])
      redirect_to account_path
    elsif params[:user_profile] && @user.profile.update_attributes(params[:user_profile])
      redirect_to account_path
    else
      render :edit
    end
  end

  def destroy
  end

end
