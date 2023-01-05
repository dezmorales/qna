require 'rails_helper'

feature 'User can view question and the list of answer to it', %q{
  To find out the answers
  As an user
  In order to resolve problem
} do
  given(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, question: question) }

  scenario 'User can view question and the list of answer to it' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each { |answer| expect(page).to have_content answer.body}

  end
end
