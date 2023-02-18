require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:question) { create(:question) }

  describe 'POST #create' do
    let(:user) { create(:user) }
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new comment in the database' do
        expect { post :create, params: { question_id: question.id, comment: attributes_for(:comment) }, format: :js }.to change(Comment, :count).by(1)
      end

      it 'render template create' do
        post :create, params: { question_id: question.id, comment: attributes_for(:comment), format: :js }
        expect(response).to render_template :create
      end
    end
  end
end
