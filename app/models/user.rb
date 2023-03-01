class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, :confirmable,
         omniauth_providers: [:github, :vkontakte]

  has_many :answers
  has_many :questions
  has_many :rewards
  has_many :votes
  has_many :comments
  has_many :authorizations
  has_many :subscriptions

  def author_of?(obj)
    obj.user_id == id
  end

  def self.find_for_oauth(auth)
    FindForOauth.new(auth).call
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
