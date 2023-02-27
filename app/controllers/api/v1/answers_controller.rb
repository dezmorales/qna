class Api::V1::AnswersController < Api::V1::BaseController
  protect_from_forgery with: :null_session, only: %i[update create destroy]
  skip_authorization_check

  def index
    @answers = question.answers
    render json: @answers
  end

  def show
    render json: answer, serializer: AnswerSeparateSerializer
  end

  def create
    @answer = questions.answers.new(answer_params.merge(user: current_resource_owner))

    if @answer.save
      render json: @answer, status: :created
    else
      render json: { errors: @answer.errors }, status: :unprocessable_entity
    end
  end

  def update
    authorize! :update, answer

    if answer.update(answer_params)
      render json: answer, status: :created
    else
      render json: { errors: 'Answer not update' }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, answer

    answer.destroy
    render json: { messages: ['Answer destroy'] }
  end


  private

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer
    @answer ||= Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
