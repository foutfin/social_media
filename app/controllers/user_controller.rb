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
      getAllFollowRequest
      getAllFollowers
      getAllFollowing

      pp "ddd #{@all_follow_requests.length}" 
    else
      isFriend
      request_sent =  FollowRequest.where(from:@current_user, to:@show_user )
      if request_sent.length == 1
        @request_sent_present = true
      else
        @request_sent_present = false
      end
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

  def accept_follow
    authenticate
    @follow_request =  FollowRequest.find(params[:reqid])
    if !@follow_request.present?
      render json: { err: ["Request not found"] }
    end
    @follow_connection = Connection.new(follow_by:@follow_request.from , follow_to:@follow_request.to)
    if @follow_connection.save
      @follow_request.approved = true
      if !@follow_request.save
        render json: { err: @follow_request.errors.full_messages}
      end
      render json: { msg: "ok"}
    else
      render json: { err: @follow_connection.errors.full_messages}
    end
  end

  def reject_follow
    authenticate
    @follow_request =  FollowRequest.find(params[:reqid])
    if !@follow_request.present?
      render json: { err: ["Request not found"] }
    end
    @follow_request.approved = false
    if !@follow_request.save
        render json: { err: @follow_request.errors.full_messages}
    end
    render json: { msg: "ok"}
  end

  private 
  def getAllFollowRequest
    @all_follow_requests = FollowRequest.where(to:@current_user , approved: nil)
  end

  def getAllFollowers
    @all_followers = Connection.where(follow_to:@current_user)
  end

  def getAllFollowing
    @all_following = Connection.where(follow_by:@current_user)
  end

  def isFriend
    is_follower = Connection.find_by( follow_by: @current_user , follow_to:@show_user)
    is_following = Connection.find_by( follow_by: @show_user , follow_to:@current_user)

    if is_follower.present? || is_following.present?
      @is_friend = true
      getShowUserPost
    else
      @is_friend = false
    end
  end
end
