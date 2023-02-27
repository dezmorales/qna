require 'rails_helper'

RSpec.describe NewAnswerNotificationService do
  let(:users) { create_list(:user, 2) }
  let(:question) { create(:question) }
  let(:subscription1) { create(:subscription, user: user.first, question: question) }
  let(:subscription2) { create(:subscription, user: user.last, question: question) }
  let(:answer) { create(:answer, question: question, user: users.first) }

  it 'sends new answer notification to all users' do
    Subscription.find_each { |subscription| expect(NewAnswerNotificationMailer).to receive(:notification).with(subscription.user, answer).and_call_original }
    NewAnswerNotification.new(answer).call
  end
end
