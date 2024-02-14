# frozen_string_literal: true

class Bid < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :price, presence: true
end
