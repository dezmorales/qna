class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :new, :destroy]
  before_action :find_question, only: [:new, :create]
  before_action :set_answer, only: [:destroy]

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to question_path(@question), notice: 'Your answer successfully created.'
    else
      render 'questions/show'
    end

  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy

      redirect_to questions_path(@answer.question), notice: 'Answer successfully deleted.'
    else
      redirect_to questions_path(@answer.question)
    end
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
