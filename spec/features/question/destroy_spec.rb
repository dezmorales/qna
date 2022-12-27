require 'rails_helper'

feature 'User can delete their question', %q{
  In order to delete question
  As an authenticated user
  I'd like to be able to delete my questions
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user deletes question' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete question'

    expect(page).to have_content 'Question successfully deleted.'
  end

  scenario 'Unauthenticated user deletes question' do
    visit question_path(question)

    expect(page).to have_no_link('Delete question', href: question_path(question))
  end
end
