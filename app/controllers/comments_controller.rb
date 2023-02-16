class CommentsController < ApplicationController
  before_action :authenticate_user!
  after_action :publish_comment, only: [:create]

  def create
    @comment = commentable.comments.create(comment_params.merge(user: current_user))
  end

  private

  def publish_comment
    html = ApplicationController.render(
      partial: 'comments/comment',
      locals: { comment: @comment }
    )

    ActionCable.server.broadcast(
      "comments_question_#{params[:question]}",
      { html:,
        author_id: @comment.user.id,
        commentable_selector: "#{@commentable.class.name.underscore}-#{@commentable.id}" }
    )
  end

  def commentable
    commentables = [Question, Answer]
    commentable_class = commentables.find { |klass| params["#{klass.name.underscore}_id"] }
    @commentable = commentable_class.find(params["#{commentable_class.name.underscore}_id"])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
