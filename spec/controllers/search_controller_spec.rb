require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  let!(:question) { create(:question) }
  let(:service) { SearchService.new(question.title, 'Question') }

  describe 'GET #index' do
    before {
      allow(SearchService).to receive(:new).with(question.title, 'Question').and_return(service)
      allow(service).to receive(:call).and_return([question])
      get :index, params: { query: question.title, scope: 'Question' }
    }

    it 'assigns @result' do
      expect(assigns(:result)).to eq([question])
    end

    it 'renders index' do
      expect(response).to render_template :index
    end
  end
end
