class PostController < ApplicationController
  include AuthHelper
  include UserHelper

  def index
    authenticate
    @posts = @current_user.posts.all
  end

  def new
    authenticate
    @post = @current_user.posts.new
  end

  def create
    authenticate
    @post = @current_user.posts.new(caption:params[:caption],
                      body: params[:body])
    if @post.save
        redirect_to action: 'index'
    else
      flash[:error] = @post.errors.full_messages
      render action: 'create'
    end
  end

  def show
    authenticate
    @current_post = Post.find(params[:id])
    if !@current_post.present? 
      render template: 'post/post_not_found'
    end
    sameFollowing @current_post.user
  end

  def edit
    authenticate
    @edit_post = Post.find(params[:id])
    if !@edit_post.present?
      render action: 'index'
    end
  end

  def update
    if @edit_post == nil 
      @edit_post = Post.find(params[:id])
    end
    @edit_post.caption = params[:caption]
    @edit_post.body = params[:body]

    if @edit_post.save
      redirect_to "/post/#{params[:id]}" 
    else
      render plain: @edit_post.errors.full_message
    end
  end

  def destroy
    authenticate
    begin
      @current_user.posts.destroy(params[:id])
    rescue => e
      puts "Error #{e}"
      render json: { err: "something goes wrong"}
    end
    render json: { msg: "ok"  } 
  end

  def like
    authenticate
    @current_post = post.find(params[:id])
    if !@current_post.present? 
      render template: 'post/post_not_found'
    end
    samefollowing @current_post.user
    if !@is_friend 
      render json: { err: "not following"}
    end
    @current_post.likes += 1
    if !@current_post.save
        render json: { err: @current_post.errors.full_message}
    end
    render json: {msg:"ok" , likes:@current_post.likes }
  end

  def dislike
    authenticate
    @current_post = Post.find(params[:id])
    if !@current_post.present? 
      render template: 'post/post_not_found'
    end
    sameFollowing @current_post.user
    if !@is_friend 
      render json: { err: "not following"}
    end
    @current_post.dislikes -= 1
    if !@current_post.save
        render json: { err: @current_post.errors.full_message}
    end
    render json: {msg:"ok" , likes:@current_post.likes }
  end

  def archive
    authenticate
    fetched_post = @current_user.posts.find(params[:id])
    if !fetched_post.present?
        render json: { err: "Post is not found"}
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

    if is_follower.present? || is_following.present?
      @is_friend = true
    else
      @is_friend = false
    end
  end
end
