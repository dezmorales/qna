require 'rails_helper'

RSpec.describe SearchService do
  let(:search)   { described_class }
  let(:question) { create(:question) }

  it 'search in ThinkingSphinx - All' do
    allow(ThinkingSphinx).to receive(:search).with(question.title).and_return [question]
    search.new(question.title, 'All').call

    expect(ThinkingSphinx).to have_received(:search)
  end

  it 'search in QuestionsIndex' do
    allow(question.class).to receive(:search).with(question.title).and_return [question]
    search.new(question.title, 'Question').call

    expect(question.class).to have_received(:search)
  end
end
