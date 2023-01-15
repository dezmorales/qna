require 'rails_helper'

feature 'User can write an answer to the question', %q{
  In order to answer somebody's question
  As an authenticated user
  I'd like to be able to create an answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'creates an answer' do
      fill_in 'Body', with: 'answer text'
      click_on 'Add an answer'

      expect(page).to have_content 'answer text'
      expect(page).to have_content 'Your answer successfully created.'
    end

    scenario 'creates an answer with errors' do
      click_on 'Add an answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user creates answer' do
    visit question_path(question)

    fill_in 'Body', with: 'answer text'
    click_on 'Add an answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
