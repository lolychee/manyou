class Users::SessionsController < ApplicationController
  def new
  end

  def create
    user = User.authenticate(params[:user][:login], params[:user][:password])
    if user
      self.current_user = user

      remember_me if params[:user][:remember_me] == "1"

      flash[:notice] = "Logged in successfully."
      redirect_back_or_default(root_url)
    else
      logout
      flash.now[:error] = "Invalid login or password."
      render :action => 'new'
    end
  end

  def destroy
    logout
    flash[:notice] = "You have been logged out."
    redirect_to root_url
  end
end
