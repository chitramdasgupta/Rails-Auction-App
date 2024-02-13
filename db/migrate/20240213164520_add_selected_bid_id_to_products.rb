class AddSelectedBidIdToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :selected_bid_id, :integer
  end
end
