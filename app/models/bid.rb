class Bid < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :price, presence: true
end
