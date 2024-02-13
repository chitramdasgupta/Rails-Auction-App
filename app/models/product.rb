class Product < ApplicationRecord
  belongs_to :user
  belongs_to :selected_bid, class_name: 'Bid', optional: true

  has_many :bids, dependent: :destroy
end
