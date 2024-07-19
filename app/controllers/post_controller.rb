class PostController < ApplicationController
  include AuthHelper
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
    # authenticate
    # Post.find(params[])
  end

  def like
  end

  def dislike
  end

end
