class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @best_answer = @question.best_answer
    @other_answers = @question.answers.where.not(id: @question.best_answer_id)
  end

  def new
    @question = Question.new
  end

  def edit
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    if current_user.author_of?(@question)
      @question.update(question_params)
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy

      redirect_to questions_path, notice: 'Question successfully deleted.'
    else
      redirect_to questions_path
    end
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end


