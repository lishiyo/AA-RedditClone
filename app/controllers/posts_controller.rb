class PostsController < ApplicationController

  before_action :set_post, only: [:show, :edit, :update, :require_current_author]
  before_action :require_current_author, only: [:edit, :update]

  def show
  end

  def new
    @post = Post.new
  end

  def create
    # current_user now @post's author
    @post = current_user.posts.build(post_params)

    if @post.save
      redirect_to post_url(@post)
    else
      flash.now[:errors] = "Couldn't create post."
      render :new
    end

  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to post_url(@post)
    else
      flash.now[:errors] = "Couldn't update post."
      render :edit
    end
  end

  private

  def require_current_author
    unless current_user = @post.author
      redirect_to post_url(@post), notice: "You are not authorized to edit this post."
    end
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :url, :content, :sub_id, :user_id)
  end

end