require 'rails_helper'

describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) {create :user}
    let(:other) { create :user }

    let(:question) { create(:question, user: user) }
    let(:other_question) { create(:question, user: other) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:other_answer) { create(:answer, question: other_question, user: other) }
    let(:link) { create(:link, linkable: question) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, question }
    it { should_not be_able_to :update, other_question}

    it { should be_able_to :update, answer }
    it { should_not be_able_to :update, other_answer }

    it { should be_able_to :update, create(:comment, commentable: question, user: user) }
    it { should_not be_able_to :update, create(:comment, commentable: question, user: other) }

    it { should be_able_to :mark_as_best, answer }
    it { should_not be_able_to :mark_as_best, other_answer }

    it { should be_able_to :destroy, question }
    it { should_not be_able_to :destroy, other_question}

    it { should be_able_to :destroy, answer }
    it { should_not be_able_to :destroy, other_answer}

    it { should be_able_to :destroy_link, question }
    it { should_not be_able_to :destroy_link, other_question }

    it { should be_able_to :destroy_link, answer }
    it { should_not be_able_to :destroy_link, other_answer }
  end
end
