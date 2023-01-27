require 'rails_helper'

feature 'User can delete their answer files', %q{
  To fix a errors
  As an authenticated user
  I can delete a answer files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }

  background do
    answer.files.attach(
      io: File.open(Rails.root.join('spec', 'rails_helper.rb')),
      filename: 'rails_helper.rb'
    )
  end

  describe 'Authenticated user', js: true  do

    scenario 'deletes their answer files' do
      sign_in(user)
      visit question_path(question)

      click_on 'Delete file'

      expect(page).to_not have_content answer.files.first.filename.to_s
    end

    scenario "does not see a link to delete files another user's answer" do
      sign_in(create(:user))
      visit question_path(question)

      expect(page).to have_no_link('Delete file', href: destroy_file_answer_path(answer, file_id: answer.files.first.id))
    end
  end
  scenario 'Unauthenticated user deletes answer files', js: true  do
    visit question_path(question)
    expect(page).to have_no_link('Delete file', href: destroy_file_answer_path(answer, file_id: answer.files.first.id))
  end
end
