require 'rails_helper'

feature 'User can add a comment', %q{
  To clarify information
  As an authenticated user
  I'd like to be add a comment
} do
  describe "mulitple sessions" do
    given(:user) { create(:user) }
    given(:question) { create(:question) }

    scenario "comments appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.comments' do
        fill_in 'Your body', with: 'comments test text'
        click_on 'Save'
        end
        expect(page).to have_content 'comments test text'
      end

      Capybara.using_session('guest') do

        expect(page).to have_content 'comments test text'
      end
    end
  end
end
