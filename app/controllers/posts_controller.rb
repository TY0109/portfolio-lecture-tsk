class PostsController < ApplicationController
  before_action :set_post, only:[:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :admin_or_limitation_correct_user, only:[:edit, :update, :destroy]
  
  def index
    @search = Post.ransack(params[:q])
    @posts = @search.result.order(created_at: :desc)
  end
  
  def new
    @post = current_user.posts.build
  end
  
  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = "新規投稿に成功しました"
      redirect_to posts_url
    else
      render :new
    end
  end
  
  def show
    @post = Post.find(params[:id])
    @likes_count = Like.where(post_id: @post.id).count
    
    # 詳細はshowページのビューにコメントアウトで記載
    @comment = @post.comments.build
    @comment_reply = @post.comments.build
    @comments = @post.comments
  end
  
  def edit; end
  
  def update
    if @post.update(post_params)
      flash[:success]="投稿を編集しました"
      redirect_to posts_url 
    else
      render :edit
    end
  end
  
  def destroy
    @post.destroy
    flash[:success]="投稿を削除しました"
    redirect_to posts_path 
  end
  
  private
  
    def post_params
      params.require(:post).permit(:university, :department, :branch, :title, :description, :img, :remove_img)
    end
    
    def set_post
      @post = Post.find(params[:id])
    end
    
    def admin_or_limitation_correct_user
      @post = Post.find(params[:id])
      unless @post.user_id == current_user.id  || current_user.admin?
        flash[:info]="自分以外のユーザーの投稿は編集できません"
        redirect_to posts_url
      end
    end
end
