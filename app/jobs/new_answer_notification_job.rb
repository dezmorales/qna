class NewAnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    NewAnswerNotification.new(answer).call
  end
end
