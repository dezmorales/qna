require 'rails_helper'

feature 'User can subscribe and unsubscribe from question', %q{
  In order to get new answers from question
  As an authinticated user
  I'd like to be able to subscribe and unsubscribe from question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authinticated user' do
    background { sign_in(user) }

    describe 'as author' do
      background do
        visit questions_path
        click_on 'Ask question'

        fill_in 'Title', with: 'Some question'
        fill_in 'Body', with: 'Some text'

        click_on 'Ask'
      end

      scenario 'subscribe on question automatically' do
        expect(page).to have_content 'Unsubscribe'
      end

      scenario 'can unsubscribe from his question' do
        click_on 'Unsubscribe'

        expect(page).to have_content 'You are unsubscribed from this question.'
        expect(page).to have_content 'Subscribe'
      end
    end

    scenario 'can subscribe on question' do
      visit question_path(question)
      click_on 'Subscribe'

      expect(page).to have_content 'You successfuly subscribed!'
      expect(page).to have_content 'Unsubscribe'
    end

    scenario 'can unsubscribe from question' do
      visit question_path(question)
      click_on 'Subscribe'
      click_on 'Unsubscribe'

      expect(page).to have_content 'You are unsubscribed from this question.'
      expect(page).to have_content 'Subscribe'
    end
  end

  scenario 'Unauthinticated user tries to subscribe' do
    visit question_path(question)
    expect(page).to_not have_content 'Subscribe'
  end
end
