class CommentsChannel < ApplicationCable::Channel
  def follow
    stream_from "comments_question_#{params[:question]}"
  end
end
