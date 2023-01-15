require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:answer) { create(:answer) }
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'GET #new' do
    before { login(user) }

    before { get :new, params: { question_id: question } }

    it 'assigns the requested Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'save a new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }.to change(Answer, :count).by(1)
      end

      it 'redirects to question' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question } }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }
        expect(response).to render_template :show
      end
    end
  end

  describe 'DELETE @destroy' do
    let(:user) { create(:user) }
    let(:author) { create(:user) }
    let!(:answer) { create(:answer, user: author) }

    context 'user is answer author' do
      before { login(author) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question page' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to questions_path(answer.question)
      end
    end

    context 'user is not answer author' do
      before { login(user) }

      it 'not deletes the question' do
        expect { delete :destroy, params: { id: answer } }.not_to change(Question, :count)
      end

      it 'redirects to question page' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to questions_path(answer.question)
      end
    end
  end
end

