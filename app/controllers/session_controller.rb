class SessionController < ApplicationController
  def loginView
    render layout: 'bare'
  end

  def login
    flash[:error] ||= []
    required_params = [:username , :password]
    params_all = required_params.all? do |k|
      if params[k].nil? || params[k].empty?
        flash[:error] << "Missing #{k.to_s}"
        false
      else
        true
      end
    end
    if !params_all
      render action: 'loginView' , layout: 'bare'
      return
    end
    @user = User.find_by(username: params[:username])
    if @user.present? && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to '/home'
    else
      flash[:error] = [ "check username and password"]
      render action: 'loginView' , layout: 'bare'
    end
  end

  def logout
    session[:user_id] = nil
    @current_user = nil
    redirect_to "/"
  end

end
