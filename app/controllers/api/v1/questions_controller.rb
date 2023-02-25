class Api::V1::QuestionsController < Api::V1::BaseController
  protect_from_forgery with: :null_session, only: %i[update create destroy]
  skip_authorization_check

  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    render json: question, serializer: QuestionSeparateSerializer
  end

  def create
    @question = current_resource_owner.questions.new(question_params)

    if @question.save
      render json: @question, status: :created
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  def update
    authorize! :update, question

    if question.update(question_params)
      render json: question, status: :created
    else
      render json: { errors: 'Question not update' }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, question

    question.destroy
    render json: { messages: ['Question destroy'] }
  end

  private

  def question
    @question ||= Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
