require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many :answers }
  it { should have_many :questions }
  it { should have_many :rewards }
  it { should have_many :votes }
  it { should have_many :comments }
  it { should have_many :comments }
  it { should have_many :authorizations }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'author_of?' do
    let(:user) { create(:user) }
    let(:author) { create(:user) }
    let(:answer) { create(:answer, user: author) }
    let(:question) { create(:question, user: author) }

    it { expect(author.author_of?(answer)).to be_truthy }
    it { expect(author.author_of?(question)).to be_truthy }
    it { expect(user.author_of?(answer)).to be_falsey }
    it { expect(user.author_of?(question)).to be_falsey }
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:service) { double('FindForOauth') }

    it 'calls FindForOauth' do
      expect(FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end
end
