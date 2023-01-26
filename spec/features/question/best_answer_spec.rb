require 'rails_helper'

feature 'Author of question can choose the best answer', %q{
  To show a working answer
  As an author of question
  I can choose the best answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: create(:user)) }
  given!(:another_answer) { create(:answer, question: question, user: create(:user)) }

  describe 'Author of question' do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'chose the best answer', js: true do
      find("#answer-#{answer.id} .best_answer_link").click

      within '.best_answer' do
        expect(page).to have_content answer.body
      end
    end

    scenario 'chose the another best answer', js: true do
      find("#answer-#{answer.id} .best_answer_link").click

      find("#answer-#{another_answer.id} .best_answer_link").click

      within '.best_answer' do
        expect(page).to have_content another_answer.body
      end
    end
  end

  scenario 'Not the author of the question does not see the link', js: true do
    sign_in create(:user)
    visit question_path(question)

    expect(page).to have_no_link('Mark as best')
  end
end
