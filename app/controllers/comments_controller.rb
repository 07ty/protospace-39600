class CommentsController < ApplicationController
  def create
    @prototype = Prototype.find(params[:prototype_id])
    @comment = @prototype.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to prototype_path(@prototype), notice: 'コメントが投稿されました。'
    else
      redirect_to prototype_path(@prototype), alert: 'コメントの投稿に失敗しました。'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end