class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many_attached :files
  belongs_to :user
  belongs_to :best_answer, class_name: 'Answer', optional: true

  validates :title, :body, presence: true
end
