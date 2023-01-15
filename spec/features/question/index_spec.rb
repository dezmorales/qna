require 'rails_helper'

feature 'User view the list question', %q{
  To find the answer to my question
  As an user
  I'd like to be able to view the list questions
} do

  given!(:questions) { create_list(:question, 3) }

  scenario 'User views the list of questions' do
    visit questions_path

    questions.each { |question| expect(page).to have_content question.title}
  end
end