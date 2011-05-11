class Member::SessionsController < ApplicationController

  def new
    @session = UserSession.new
  end

  def create
    current_user_session = UserSession.create params[:session] if params[:session]
    if current_user_session
      flash[:notice] = 'Logged in successfully.'
      redirect_back_or_default root_path
    else
      flash.now[:error] = 'Invalid login or password.'
      render :new
    end
  end

  def destroy
    current_user_session.destroy
  end

end
