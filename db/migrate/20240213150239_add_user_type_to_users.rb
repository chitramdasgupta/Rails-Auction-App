# frozen_string_literal: true

class AddUserTypeToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :user_type, :string, default: 'buyer'
  end
end
