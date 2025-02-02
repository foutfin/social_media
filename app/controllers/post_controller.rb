class PostController < ApplicationController
  include AuthHelper
  include UserHelper
  before_action :authenticate

  def index
    redirect_to "/user/#{@current_user.username}"
  end

  def new
    @post = @current_user.posts.new
  end

  def create
    flash[:error] ||= []
    required_params = [:caption]
    params_all = required_params.all? do |k|
      if params[k].nil? || params[k].empty?
        flash[:error] << "Missing #{k.to_s}"
        false
      else
        true
      end
    end
  
    if !params_all
      render action: 'new' 
      return
    end
    if (params[:body].empty? || params[:body].nil?) && ( params[:media] == nil)
      flash[:error] << "Both body and media can't be empty"
      render action: "new"
      return
    end
    @post = @current_user.posts.new(caption:params[:caption],
                      body: params[:body])
    if params[:media] != nil
      if !@post.media.attach(params[:media])
        flash[:error] = ["Something went wrong in media upload"]
        render action: 'new' 
      end
    end

    if @post.save
        flash[:success] = ["Post Created Successfully"]
        redirect_to action: 'index'
    else
      flash[:error] = @post.errors.full_messages
      render action: 'new'
    end
  end

  def show
    begin
      @current_post = Post.find(params[:id])
    rescue
      render template: 'post/post_not_found'
      return
    end
    sameFollowing @current_post.user
    @same_user = @current_post.user.id == @current_user.id
  end

  def edit
    begin
      @edit_post = Post.find(params[:id])
    rescue
      render action: 'index'
    end
  end

  def update
    if @edit_post == nil 
      begin
        @edit_post = Post.find(params[:id])
      rescue
        flash[:error] = ["something went wrong"] 
        redirect_to "/post/#{params[:id]}" 
        return
      end
    end
    @edit_post.caption = params[:caption]
    @edit_post.body = params[:body]

    if @edit_post.save
      redirect_to "/post/#{params[:id]}" 
    else
      flash[:error] =  @edit_post.errors.full_message
      redirect_to "/post/#{params[:id]}" 
    end
  end

  def destroy
    begin
      @current_user.posts.destroy(params[:id])
    rescue
      render json: { err: "something goes wrong"}
      return
    end
    render json: { msg: "ok"  } 
  end

  def like

    begin
      @current_post = Post.find(params[:id])
    rescue 
      render json: { err: "post not found" }
      return
    end

    if @current_user.id != @current_post.user.id 
      sameFollowing @current_post.user
      if !@is_friend 
        render json: { err: "not following"}
        return
      end
    end

    @current_post.likes += 1
    like = @current_user.history.new(post:@current_post,status: :liked)
    if @current_post.save && like.save
      render json: {msg:"ok" , likes:@current_post.likes }
    else
      render json: { err: @current_post.errors.full_message }
      
    end
  end

  def dislike
    begin
      @current_post = Post.find(params[:id])
    rescue 
      render json: { err: "post not found" }
      return
    end

    if @current_user.id != @current_post.user.id 
      sameFollowing @current_post.user
      if !@is_friend 
        render json: { err: "not following"}
        return
      end
    end

    @current_post.dislikes += 1
    dislike = @current_user.history.new(post:@current_post,status: :disliked)
    if @current_post.save && dislike.save
      render json: {msg:"ok" , dislikes:@current_post.dislikes }
    else
      render json: { err: @current_post.errors.full_message}
    end
  end

  def archive

    begin
      fetched_post = @current_user.posts.find(params[:id])
    rescue
      render json: { err: "Post is not found"}
      return
    end
    
    fetched_post.archived = true
    if !fetched_post.save
        render json: { err: fetched_post.errors.full_message }
    end
    render json: { msg: "ok"} 
  end


  private

  def sameFollowing(show_user)
    is_follower = Connection.find_by( follow_by: @current_user , follow_to:show_user)
    is_following = Connection.find_by( follow_by: show_user , follow_to:@current_user)
    pp "Foloweer fds #{is_follower.present?} #{is_following.present?}"
    if is_follower.present? || is_following.present?
      @is_friend = true
    else
      @is_friend = false
    end
  end
end
