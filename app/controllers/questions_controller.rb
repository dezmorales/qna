class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :update, :destroy, :destroy_file]
  after_action :publish_question, only: [:create]

  include Voted

  def index
    @questions = Question.all
  end

  def show
    @best_answer = @question.best_answer
    @other_answers = @question.answers.where.not(id: @question.best_answer_id)
    @answer = Answer.new
    @answer.links.new
  end

  def new
    @question = Question.new
    @question.links.new
    @question.build_reward
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

  def destroy_file
    if current_user.author_of?(@question)
      @file = ActiveStorage::Attachment.find(params[:file_id])
      @file.purge
    end
  end

  def publish_question
    return if @question.errors.any?
    binding.pry

    ActionCable.server.broadcast('questions_channel',
       ApplicationController.render(partial: 'questions/question',
                                    locals: { question: @question })
    )
  end

  private

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(
      :title,
      :body,
      files: [],
      links_attributes: [:id, :name, :url, :_destroy],
      reward_attributes: [:title, :image_url]
    )
  end
end


