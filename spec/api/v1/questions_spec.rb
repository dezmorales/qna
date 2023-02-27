require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) {{"ACCEPT" => 'application/json'}}

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) {create(:access_token)}
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before {get api_path, params: {access_token: access_token.token}, headers: headers}

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:comments) { create_list(:comment, 2, commentable: question, user: user) }
    let!(:links) { create_list(:link, 2, linkable: question) }

    before do
      question.files.attach(
        io: File.open(Rails.root.join('spec', 'rails_helper.rb')),
        filename: 'rails_helper.rb'
      )
    end
    let(:api_path) { "/api/v1/questions/#{question.id}" }

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
        let(:attrs) { %w[id title body created_at updated_at] }
        let(:resource_response) { json['question'] }
        let(:resource) { question }
      end

      describe 'comments' do
        it_behaves_like 'Returns list' do
          let(:resource_response) { json['question']['comments'] }
          let(:resource) { comments }
        end
      end

      describe 'files' do
        it_behaves_like 'Returns list' do
          let(:resource_response) { json['question']['files'] }
          let(:resource) { question.files }
        end
      end

      describe 'links' do
        it_behaves_like 'Returns list' do
          let(:resource_response) { json['question']['links'] }
          let(:resource) { links }
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      context 'with valid attributes' do
        before do
          patch api_path, params: { id: question,
                                    question: { title: 'title', body: 'body' },
                                    access_token: access_token.token }
        end

        it 'changes question' do
          question.reload

          expect(question.title).to eq 'title'
          expect(question.body).to eq 'body'
        end

        it 'returns status :created' do
          expect(response.status).to eq 201
        end
      end

      context 'with invalid attributes' do
        before do
          patch api_path, params: { id: question,
                                    question: { title: '', body: '' },
                                    access_token: access_token.token }
        end

        it 'does not change attributes of question' do
          question.reload

          expect(question.title).to_not eq 'new title'
          expect(question.body).to_not eq 'new body'
        end

        it 'returns status :unprocessible_entity' do
          expect(response.status).to eq 422
        end

        it 'returns error message' do
          expect(json['errors']).to be
        end
      end
    end

    context 'not an author tries to update question' do
      let(:other_user) { create(:user) }
      let(:other_question) { create(:question, user: other_user) }
      let(:other_api_path) { "/api/v1/questions/#{other_question.id}" }

      before do
        patch other_api_path, params: { id: other_question,
                                        question: { title: 'new title', body: 'new_body' },
                                        access_token: access_token.token }
      end

      it 'returns status 302' do
        expect(response.status).to eq 302
      end

      it 'can not change question attributes' do
        other_question.reload

        expect(other_question.title).to eq other_question.title
        expect(other_question.body).to eq other_question.body
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:api_path) { "/api/v1/questions" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      before do
        post api_path, params: { question: attributes_for(:question), access_token: access_token.token }, headers: headers
      end

      it 'saves a new question in the database' do
        expect(Question.count).to eq 1
      end

      it 'returns status :created' do
        expect(response.status).to eq 201
      end
    end

    context 'with invalid attributes' do
      before do
        post api_path, params: { question: attributes_for(:question, :invalid), access_token: access_token.token }, headers: headers
      end

      it 'does not change attributes of question' do
        expect { post api_path, params: { question: attributes_for(:question, :invalid), access_token: access_token.token } }.to_not change(Question, :count)
      end

      it 'returns status :unprocessible_entity' do
        expect(response.status).to eq 422
      end

      it 'returns error message' do
        expect(json['errors']).to be
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      context 'with valid attributes' do
        before do
          patch api_path, params: { id: question,
                                    question: { title: 'title', body: 'body' },
                                    access_token: access_token.token }
        end

        it 'changes question' do
          question.reload

          expect(question.title).to eq 'title'
          expect(question.body).to eq 'body'
        end

        it 'returns status :created' do
          expect(response.status).to eq 201
        end
      end

      context 'with invalid attributes' do
        before do
          patch api_path, params: { id: question,
                                    question: { title: '', body: '' },
                                    access_token: access_token.token }
        end

        it 'does not change attributes of question' do
          question.reload

          expect(question.title).to_not eq 'new title'
          expect(question.body).to_not eq 'new body'
        end

        it 'returns status :unprocessible_entity' do
          expect(response.status).to eq 422
        end

        it 'returns error message' do
          expect(json['errors']).to be
        end
      end
    end

    context 'not an author tries to update question' do
      let(:other_user) { create(:user) }
      let(:other_question) { create(:question, user: other_user) }
      let(:other_api_path) { "/api/v1/questions/#{other_question.id}" }

      before do
        patch other_api_path, params: { id: other_question,
                                        question: { title: 'new title', body: 'new_body' },
                                        access_token: access_token.token }
      end

      it 'returns status 302' do
        expect(response.status).to eq 302
      end

      it 'can not change question attributes' do
        other_question.reload

        expect(other_question.title).to eq other_question.title
        expect(other_question.body).to eq other_question.body
      end
    end
  end

  describe 'DELETE /api/v1/questions' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    before do
      delete api_path, params: { id: question, access_token: access_token.token }, headers: headers
    end

    it 'destroy question in the database' do
      expect(Question.count).to eq 0
    end
  end
end
