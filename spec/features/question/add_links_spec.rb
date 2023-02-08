require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:url) { 'https://https://www.google.com' }
  given(:other_url) { 'https://github.com' }
  given(:gist_url) { 'https://gist.github.com/dezmorales/8e583f8045d5cb445987ea3fa23c21a6' }

  background do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
  end

  scenario 'User adds link when asks question', js: true do
    fill_in 'Link name', with: 'My link'
    fill_in 'Url', with: url

    click_on 'add link'

    within '#links .nested-fields:nth-of-type(2)' do
      fill_in 'Link name', with: 'Other link'
      fill_in 'Url', with: other_url
    end

    click_on 'Ask'

    expect(page).to have_link 'My link', href: url
    expect(page).to have_link 'Other link', href: other_url
  end

  scenario 'User add gist link', js: true do
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    expect(page).to have_css "script[src='#{gist_url}.js']", visible: false
  end
end
