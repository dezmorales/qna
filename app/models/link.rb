class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  URl_FORMAT = /(http|https):/

  validates :name, :url, presence: true
  validates :url, format: { with: URl_FORMAT }

end
