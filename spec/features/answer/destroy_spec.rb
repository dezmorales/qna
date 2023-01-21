require 'rails_helper'

feature 'User can delete their answer to the question', %q{
  In order to delete wrong answer
  As an authenticated user
  I'd like to be able to delete my answers
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, user: user, question: question) }

  describe 'Authenticated user' do

    scenario 'can delete your answer', js: true do
      sign_in(user)
      visit question_path(question)
      click_on 'Delete answer'

      expect(page).to have_no_content answer.body
    end

    scenario "can't deletes someone else's answer" do
      another_user = create(:user)
      sign_in(another_user)
      visit question_path(question)

      expect(page).to have_no_link('Delete answer', href: answer_path(answer))
    end
  end

  scenario 'Unauthenticated user deletes answer' do
    visit question_path(question)

    expect(page).to have_no_link('Delete answer', href: answer_path(answer))
  end
end
