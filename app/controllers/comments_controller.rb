class CommentsController < ApplicationController
  def create
    post = Post.find(params[:post_id])
    @comment = Comment.create(comment_params)
    @comment.post = post
    @comment.author = Current.user
    if @comment.save
      flash[:notice] = 'Comment added successfully.'
      redirect_to user_post_path(post.author, post)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.destroy
    redirect_to user_post_url(current_user, comment.post), notice: 'Comment was successfully destroyed.'
  end

  private

  def comment_params
    params.permit(:text)
  end
end
