require 'rails_helper'

feature 'User can delete their question files', %q{
  To fix a errors
  As an authenticated user
  I can delete a question files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  background do
    question.files.attach(
      io: File.open(Rails.root.join('spec', 'rails_helper.rb')),
      filename: 'rails_helper.rb'
    )
  end

  describe 'Authenticated user', js: true  do

    scenario 'deletes their question files' do
      sign_in(user)
      visit question_path(question)

      click_on 'Delete file'

      expect(page).to_not have_content question.files.first.filename.to_s
    end

    scenario "does not see a link to delete another user's question files" do
      sign_in(create(:user))
      visit question_path(question)

      expect(page).to have_no_link('Delete file', href: destroy_file_question_path(question, file_id: question.files.first.id))
    end
  end
  scenario 'Unauthenticated user deletes question files', js: true  do
    visit question_path(question)
    expect(page).to have_no_link('Delete file', href: destroy_file_question_path(question, file_id: question.files.first.id))
  end
end
