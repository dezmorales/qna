require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do
  let(:service) { double('NewAnswerNotification') }
  let(:user) { create(:user) }
  let(:answer) { create(:answer, question: create(:question), user: user) }

  before do
    allow(NewAnswerNotification).to receive(:new).with(answer).and_return(service)
  end

  it 'calls NewAnswerNotification#send_digest' do
    expect(service).to receive(:call)
    NewAnswerNotificationJob.perform_now(answer)
  end
end
