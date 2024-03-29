class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :new, :destroy]
  before_action :find_question, only: [:new, :create]
  before_action :set_answer, only: [:destroy, :update, :mark_as_best, :destroy_file]
  after_action :publish_answer, only: [:create]

  include Voted

  authorize_resource

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.create(answer_params)
    @answer.user = current_user

    @answer.save

    @answer_comment = @answer.comments.new
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
    @answer.question.update(best_answer_id: @answer.id)
    if @answer.question.reward
      @answer.question.reward.update(user: @answer.user)
    end
  end

  def destroy_file
    if current_user.author_of?(@answer)
      @file = ActiveStorage::Attachment.find(params[:file_id])
      @file.purge
    end
  end

  def publish_answer
    html = ApplicationController.renderer.new(warden: warden).render(
      partial: 'answers/answer_simple',
      locals: { answer: @answer }
    )

    ActionCable.server.broadcast(
      "question_#{@question.id}",
      { html:, author_id: @answer.user.id }
    )
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:id, :name, :url, :_destroy])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end
end
