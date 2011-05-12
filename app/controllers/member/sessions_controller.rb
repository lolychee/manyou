class Member::SessionsController < ApplicationController

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new params[:user_session]
    if @user_session.save
      flash[:notice] = 'Logged in successfully.'
      redirect_back_or_default root_path
    else
      #flash.now[:error] = 'Invalid login or password.'
      render :new
    end
  end

  def destroy
    current_user_session.destroy
  end

end
