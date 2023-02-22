class UsersController < ApplicationController
  def confirm_email
    email = user_params[:email]

    if User.find_by(email: email).nil?
      password = Devise.friendly_token[0, 20]
      user = User.new(email: email, password: password, password_confirmation: password)
      user.save!
      user.authorizations.create(provider: session[:auth_provider], uid: session[:auth_uid])
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end
end
