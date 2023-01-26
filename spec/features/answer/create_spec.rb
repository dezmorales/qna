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

    scenario 'creates an answer', js: true do
      fill_in 'Body', with: 'answer text'
      click_on 'Add an answer'

      expect(page).to have_content 'answer text'
    end

    scenario 'creates an answer with errors', js: true do
      click_on 'Add an answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'asks a answer with many attached files', js: true do
        fill_in 'Body', with: 'Test answer'

        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Add an answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user creates answer' do
    visit question_path(question)

    fill_in 'Body', with: 'answer text'
    click_on 'Add an answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
