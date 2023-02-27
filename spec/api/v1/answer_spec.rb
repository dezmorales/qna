require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) {{"ACCEPT" => 'application/json'}}

  describe 'GET /api/v1/question/:question_id/answers' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:answers) { create_list(:answer, 2, question: question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) {create(:access_token)}
      let(:answer_response) { json['answers'].first }

      before {get api_path, params: {access_token: access_token.token}, headers: headers}

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['answers'].size).to eq answers.size
      end

      it_behaves_like 'Returns list' do
        let(:resource_response) { json['answers'] }
        let(:resource) { answers }
      end

      it_behaves_like 'Returns public fields' do
        let(:attrs) { %w[id body user_id created_at updated_at] }
        let(:resource_response) { json['answers'].first }
        let(:resource) { answers.first }
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, user: user, question: question) }
    let!(:comments) { create_list(:comment, 2, commentable: answer, user: user) }
    let!(:links) { create_list(:link, 2, linkable: answer) }

    before do
      answer.files.attach(
        io: File.open(Rails.root.join('spec', 'rails_helper.rb')),
        filename: 'rails_helper.rb'
      )
    end
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) {create(:access_token)}

      before {get api_path, params: {access_token: access_token.token}, headers: headers}

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it_behaves_like 'Returns public fields' do
        let(:attrs) { %w[id body user_id created_at updated_at] }
        let(:resource_response) { json['answer'] }
        let(:resource) { answer }
      end

      describe 'comments' do
        it_behaves_like 'Returns list' do
          let(:resource_response) { json['answer']['comments'] }
          let(:resource) { comments }
        end
      end

      describe 'files' do
        it_behaves_like 'Returns list' do
          let(:resource_response) { json['answer']['files'] }
          let(:resource) { answer.files }
        end
      end

      describe 'links' do
        it_behaves_like 'Returns list' do
          let(:resource_response) { json['answer']['links'] }
          let(:resource) { links }
        end
      end
    end
  end




  describe 'PATCH /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, user: user, question: question) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      context 'with valid attributes' do
        before do
          patch api_path, params: { id: answer,
                                    answer: { body: 'body' },
                                    access_token: access_token.token }
        end

        it 'changes answer' do
          answer.reload

          expect(answer.body).to eq 'body'
        end

        it 'returns status :created' do
          expect(response.status).to eq 201
        end
      end

      context 'with invalid attributes' do
        before do
          patch api_path, params: { id: answer,
                                    answer: { body: '' },
                                    access_token: access_token.token }
        end

        it 'does not change attributes of question' do
          answer.reload

          expect(answer.body).to_not eq 'new body'
        end

        it 'returns status :unprocessible_entity' do
          expect(response.status).to eq 422
        end

        it 'returns error message' do
          expect(json['errors']).to be
        end
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, user: user, question: question) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    before do
      delete api_path, params: { id: answer, access_token: access_token.token }, headers: headers
    end

    it 'destroy question in the database' do
      expect(Answer.count).to eq 0
    end
  end
end
