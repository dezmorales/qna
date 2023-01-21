class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :new, :destroy]
  before_action :find_question, only: [:new, :create, :mark_as_best]
  before_action :set_answer, only: [:destroy, :update]

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.create(answer_params)
    @answer.user = current_user

    @answer.save
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy

    else
      redirect_to questions_path(@answer.question)
    end
  end

  def mark_as_best
    @last_best_answers = @answer.question.best_answer
    @answer.question.update(best_answer_id: answer.id)
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end
end
