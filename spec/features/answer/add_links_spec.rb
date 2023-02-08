require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
} do

  given(:user) {create(:user)}
  given!(:question) {create(:question)}
  given(:url) { 'https://www.google.com' }
  given(:other_url) { 'https://github.com' }

  scenario 'User adds link when give an answer', js: true do
    sign_in(user)

    visit question_path(question)

    fill_in 'Body', with: 'My answer'

    fill_in 'Link name', with: 'My link'
    fill_in 'Url', with: url

    click_on 'add link'

    within '#links .nested-fields:nth-of-type(2)' do
      fill_in 'Link name', with: 'Other link'
      fill_in 'Url', with: other_url
    end

    click_on 'Add an answer'

    within '.answers' do
      expect(page).to have_link 'My link', href: url
      expect(page).to have_link 'Other link', href: other_url
    end
  end

end
