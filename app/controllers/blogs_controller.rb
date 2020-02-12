class BlogsController < ApplicationController
  before_action :verify_token, only: [:create, :update, :destroy]
  before_action :is_admin?, only: [:create, :update, :destroy]
  before_action :set_blog, only: [:show, :update, :destroy]

  def index
    blogs = Blog.super_filter(params)
    return renderCollection("blogs", blogs, BlogSerializer)
  end

  def show
    return render json: @blog, status: :ok
  end

  def create
    blog = Blog.new(blog_params)
    blog.user = @user
    if blog.save
      return render json: blog, status: :created
    else
      return renderJson(:unprocessable, {error: blog.errors.messages})
    end
  end

  def update
    @blog.assign_attributes(blog_params)
    @blog.user = @user
    if @blog.save
      return render json: @blog, status: :ok
    else
      return renderJson(:unprocessable, {error: @blog.errors.messages})
    end
  end

  def destroy
    @blog.destroy
    return renderJson(:no_content)
  end

  private

    def set_blog
      return renderJson(:not_found) unless @blog = Blog.find_by_hashid(params[:id])
    end

    def blog_params
      params.require(:blog).permit(:title, :body, :image)
    end
end
