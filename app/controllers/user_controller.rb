class UserController < ApplicationController
  include AuthHelper
  def home
    authenticate
  end
  
  def new
    @user = User.new
    render layout: 'bare'
  end
  
  def create
    @user = User.new(first_name:params[:first_name],
                      last_name: params[:last_name],
                      email:params[:email],
                      bio:params[:bio],
                      username:params[:username],
                      password:params[:password],
                      password_confirmation: params[:confirm_password] 
                    )
    if @user.save
        session[:user_id] = @user.id
        redirect_to '/login'
    else
      flash[:error] = @user.errors.full_messages
      render action: 'new' , layout: 'bare'
    end



  end
  
  def show
  end
  
  def edit 
  end
  
  def update 
  end
  
  def destroy 
  end
  
  def follow
  end
end
