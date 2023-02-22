require 'rails_helper'

feature 'User can sigin in via Oauth', %q{
  In order to more comfortable siging in/signg up
  As a guest or registered user
  I want to be able to sign in via social network
} do

  scenario 'github' do
    OmniAuth.config.add_mock(:github, { uid: '1234', info: { email: 'gitit@test.com'} })
    visit new_user_session_path
    click_on 'Sign in with GitHub'

    expect(page).to have_content 'Successfully authenticated from github account.'
    expect(current_path).to eq root_path
  end

  scenario 'vkontakte' do

    OmniAuth.config.add_mock(:vkontakte, { uid: '1234' })
    visit new_user_session_path
    click_on 'Sign in with Vkontakte'
    expect(page).to have_content 'Please confirm your email address.'

    fill_in 'Email', with: 'oauth@test.com'

    click_on 'Continue'
    open_email('oauth@test.com')
    current_email.click_link 'Confirm my account'
    expect(page).to have_content 'Your email address has been successfully confirmed.'

    visit new_user_session_path
    click_on 'Sign in with Vkontakte'

    expect(page).to have_content 'Successfully authenticated from vkontakte account.'
    expect(current_path).to eq root_path
  end
end
