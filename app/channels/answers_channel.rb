class AnswersChannel < ApplicationCable::Channel
  def follow
    stream_from "question_#{params[:question]}"
  end
end
