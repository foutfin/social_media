class UserController < ApplicationController
  include AuthHelper
  include PostHelper
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
    authenticate 
    @show_user = User.find_by(username:params[:username])
    if !@show_user.present?
        render template: 'user/notfound'
    end
    @is_the_same_user = @show_user.id == @current_user.id
    if @is_the_same_user
      getAllPost
    else
      @requset_sent =  FollowRequest.find_by(to:@show_user)
      pp "Request #{@request_sent}"
    end
  end
  
  def edit 
  end
  
  def update 
  end
  
  def destroy 
  end
  
  def follow
    authenticate
    @to_follow_user =  User.find_by(username:params[:username])
    if !@to_follow_user.present?
      render json: { err: ["user not found"] }
    end
    @follow_request =  FollowRequest.new(from:@current_user , to:@to_follow_user)

    if @follow_request.save
      render json: { msg:"ok"}
    else
      render json: { err: @follow_request.errors.full_messages}
    end
  end
end
