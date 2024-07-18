class SessionController < ApplicationController
  def loginView
    render layout: 'bare'
  end

  def login
    @user = User.find_by(username: params[:username])
    if @user.present? && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to '/home'
    else
      flash[:error] = [ "not able to logged in"]
      render action: 'loginView' , layout: 'bare'
    end
  end

  def logout
    session[:user_id] = nil
    @current_user = nil
    redirect_to '/'
  end

end
