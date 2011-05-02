class Users::AccountsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :load_user, :only => [:edit, :update, :destroy]

  def load_user
    @user = current_user
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new params[:user]
    if @user.save
      current_user= @user
      send_remember_cookie! if params[:user][:remember_me] == "1"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes params[:user]
      redirect_to edit_account_path
    else
      render :edit
    end
  end


end
