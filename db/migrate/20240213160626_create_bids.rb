# frozen_string_literal: true

class CreateBids < ActiveRecord::Migration[7.1]
  def change
    create_table :bids do |t|
      t.decimal :price
      t.references :user, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
