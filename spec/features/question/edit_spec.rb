require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like ot be able to edit my question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Unauthenticated user can not edit question', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end

  describe 'Authenticated user', js: true do
    background do
      sign_in user
      visit question_path(question)
    end
    scenario 'edits his question' do
      click_on 'Edit question'

      fill_in 'Your question', with: 'edited question'
      click_on 'Save'

      expect(page).to_not have_content question.body
      expect(page).to have_content 'edited question'
      expect(page).to_not have_selector '#edit-question'
    end

    scenario 'edits his question with many attached files' do
      click_on 'Edit question'

      within '#edit-question' do
        fill_in 'Your question', with: 'edited question'
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

        click_on 'Save'
      end

      expect(page).to have_content 'edited question'
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'edits his question with errors' do
      click_on 'Edit question'

      fill_in 'Your question', with: ''
      click_on 'Save'

      expect(page).to have_content question.body
      within '.question-errors' do
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario "tries to edit other user's question" do
      click_on 'Log out'
      user = create(:user)
      sign_in(user)
      visit question_path(question)

      within '.question' do
        expect(page).to have_no_link('Edit')
      end
    end
  end
end
