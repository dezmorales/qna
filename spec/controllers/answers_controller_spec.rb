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
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js }.to change(Answer, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js }.to_not change(Answer, :count)
      end

      it 'renders create template' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question, format: :js }
        expect(response).to render_template :create
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
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question page' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
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

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe 'PATCH #mark_as_best' do
    let(:user) { create(:user) }
    let!(:answer) { create(:answer, question: question, user: user) }

    it 'change best answer' do
      post :mark_as_best, params: { id: answer }, format: :js
      question.reload
      expect(question.best_answer).to eq answer
    end

    it 'render mark_as_best view' do
      post :mark_as_best, params: { id: answer }, format: :js
      expect(response).to render_template :mark_as_best
    end
  end
end

