class NewAnswerNotification
  attr_reader :answer

  def initialize(answer)
    @answer = answer
  end

  def call
    answer.question.subscriptions.find_each(batch_size: 500) do |subscription|
      NewAnswerNotificationMailer.notification(subscription.user, answer).deliver_later
    end
  end
end
