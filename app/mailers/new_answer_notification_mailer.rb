class NewAnswerNotificationMailer < ApplicationMailer
  def notification(user, answer)
    @answer = answer

    mail to: user.email
  end
end
