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
    render :edit
  end
  alias_method :show, :edit

  def update
    if @user.update_attributes params[:user]
      redirect_to account_path
    else
      render :edit
    end
  end

  def destroy
  end

end
