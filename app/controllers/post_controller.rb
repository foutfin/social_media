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
  end

  def edit
  end

  def update
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
