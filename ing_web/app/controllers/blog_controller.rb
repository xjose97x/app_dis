# frozen_string_literal: true

class BlogController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
    @tags = Tag.all
    @categories = Category.all
  end

  def create
    post = Post.new(post_params)
    post.author = current_user
    post.save!
    redirect_to root_path
  end

  def like_post
    post = Post.find(params[:id])

    if post.liked_by.include?(current_user)
      post.liked_by.delete(current_user)
    else
      post.liked_by << current_user
    end
    post.save!
    redirect_to "/blog/#{post.id}"
  end

  def tags_demo
    min = params[:min].presence
    max = params[:max].presence
    tags = Tag.all
    result = tags.map do |tag|
      {
        id: tag.id,
        title: tag.title,
        slug: tag.slug,
        posts_average_score: tag.posts_average_score,
        posts: tag.posts.map do |post|
          {
            id: post.id,
            title: post.title,
            summary: post.summary,
            language_tool_errors_count: post.language_tool_matches.count,
            flesk_kincaid_score: post.flesch_kincaid_score,
            final_score: post.final_score,
          }
        end
      }
    end
    result = result.sort_by { |tag| -tag[:posts_average_score] }
    if min.present?
      result = result.select { |tag| tag[:posts_average_score] >= min.to_f }
    end
    if max.present?
      result = result.select { |tag| tag[:posts_average_score] <= max.to_f }
    end
    render json: result
  end

  private

    def post_params
      params.require(:post).permit(:title, :content, :category_id, :tags)
    end
end
