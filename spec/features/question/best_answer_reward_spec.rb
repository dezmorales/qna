require 'rails_helper'

feature 'User can add reward for best answer on question creating', %(
  In order to stimulate other users to answer my question
  As an authenticated user
  I'd like to be able to add reward for best answer when I creating question
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user:) }

  background do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
  end

  scenario 'User adds reward to question' do
    fill_in 'Title', with: 'Test Question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Reward name', with: 'Name'
    fill_in 'Reward image', with: 'https://images.ru/best_image'

    click_button 'Ask'

    expect(page).to have_content question.reward.title
    expect(page['src']).to have_content 'https://images.ru/best_image'
  end
end
