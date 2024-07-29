class UserController < ApplicationController
  include AuthHelper
  include PostHelper
  include Pagy::Backend
  before_action :authenticate , except: [:new , :create]  
  
  def home
    @pagy, @records = pagy(@current_user.followed_posts.where("archived = false").order(created_at: :desc))
    postHistory
  end
  
  def new
    @user = User.new
    render layout: 'bare'
  end
  
  def create
    flash[:error] ||= []
    required_params = [:first_name , :last_name , :email  , :username , :password , :password_confirmation ]
    params_all = required_params.all? do |k|
      if params[k].nil? || params[k].empty?
        flash[:error] << "Missing #{k.to_s}"
        false
      else
        true
      end
    end
    if !params_all
      render action: 'new' , layout: 'bare'
      return
    end
   
    @user = User.new(first_name:params[:first_name],
                      last_name: params[:last_name],
                      email:params[:email],
                      bio:params[:bio],
                      username:params[:username],
                      password:params[:password],
                      password_confirmation: params[:confirm_password] 
                    )
    if params[:avatar] != nil
      @user.avatar.attach(params[:avatar])
      if !@user.avatar.attached?
        flash[:error] = [ "Avatar not able to upload"]
        render action: 'new' , layout: 'bare'
        return
      end
    end

    if @user.save
        session[:user_id] = @user.id
        redirect_to '/login'
    else
      flash[:error] = @user.errors.full_messages
      render action: 'new' , layout: 'bare'
    end
  end

  def show
    @show_user = User.find_by(username:params[:username])
    if !@show_user.present?
        render template: 'user/notfound'
        return
    end
    @is_the_same_user = ( @show_user.id == @current_user.id )
    if !@is_the_same_user
      isFriend
      if @is_friend
        postHistory
      end
      request_sent =  FollowRequest.where(from:@current_user, to:@show_user )
      if request_sent.length == 1 
        if request_sent[0].approved == nil
          @request_sent_present = 1
        elsif request_sent[0].approved == false 
          @request_sent_present = 2
        else
          @request_sent_present = 3
        end
      else
        @request_sent_present = 0
      end
    end
  end
  
  def edit 
  end
  
  def update 
    change = false
    if @current_user.first_name != params[:first_name]
      @current_user.first_name = params[:first_name]
      change = true
    end
    if @current_user.last_name != params[:last_name]
      @current_user.last_name = params[:last_name]
      change = true
    end
    if @current_user.bio != params[:bio]
      @current_user.last_name = params[:bio]
      change = true
    end

    if params[:avatar] 
      if !@current_user.avatar.attach(params[:avatar])
        flash[:error] = ["Error in uploading avatar"]
        render action: 'edit'
        return
      end
      change = true
    end

    if change && !@current_user.save
      flash[:error] = @current_user.errors.full_messages
      render action: 'edit'
      return 
    end
    redirect_to '/post'
  end
  
  def destroy 
    begin
      FollowRequest.where("from_id = ?", @current_user.id).each do |r|
        r.destroy
      end
      @current_user.destroy
      session[:user_id] = nil
      @current_user = nil
      redirect_to '/signup'
    rescue
      flash[:error] = ["Something went wrong"]
      redirect_to '/signup'
    end
  end
  
  def follow
    begin
      @to_follow_user =  User.find(params[:id])
    rescue
      render json: { err: ["user not found"] }
      return
    end

    @follow_request =  FollowRequest.new(from:@current_user , to:@to_follow_user)
    if @follow_request.save
      render json: { msg:"ok" }
    else
      render json: { err: @follow_request.errors.full_messages}
    end
  end
  
  def unfollow
    connection = Connection.find_by(follow_by:@current_user.id , follow_to:params[:id])
    if connection == nil
      render json: { err: ["connection not found"]}
      return
    end
    begin
      connection.destroy
      render json: { msg: "ok" }
    rescue 
      render json: {err: ["something went wrong"]}
    end

  end

  def accept_follow
    begin
      @follow_request =  FollowRequest.find(params[:reqid])
    rescue
      render json: { err: ["Request not found"] }
      return
    end

    @follow_connection = Connection.new(follow_by:@follow_request.from , follow_to:@follow_request.to)
    if @follow_connection.save
      begin
        @follow_request.destroy 
      rescue
        render json: { err: @follow_request.errors.full_messages}
        return
      end
      render json: { msg: "ok"}
    else
      render json: { err: @follow_connection.errors.full_messages}
    end
  end

  def reject_follow
    begin
      @follow_request =  FollowRequest.find(params[:reqid])
    rescue
      render json: { err: ["Request not found"] }
      return
    end

    @follow_request.approved = false
    if !@follow_request.save
        render json: { err: @follow_request.errors.full_messages}
        return
    end
    render json: { msg: "ok"}
  end

  private 
  
  def postHistory
    post_ids = @records.map do |p|
      p.id
    end
    @post_history ||= {}
    @current_user.history.withPostId(post_ids).each do |p|
      @post_history[p.post_id] = p.status
    end
  end

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
    connection =  Connection.where("(follow_by_id = ? and follow_to_id = ? ) or ( follow_by_id = ? and follow_to_id = ? )", @current_user, @show_user , @show_user , @current_user)
    if connection.length == 1 
      @is_friend = true
      @paggy , @records = pagy(@show_user.posts.all.order(created_at: :desc))
    else
      @is_friend = false
    end
    # is_follower = Connection.find_by( follow_by: @current_user , follow_to:@show_user)
    # is_following = Connection.find_by( follow_by: @show_user , follow_to:@current_user)

    # if is_follower.present? || is_following.present?
    #   @is_friend = true
    #   @pagy, @records = pagy(@show_user.posts.all.order(created_at: :desc))
    #   pp "is there any record #{@records} #{@records.length}"
    #   # getShowUserPost
    # else
    #   @is_friend = false
    # end
  end
end
