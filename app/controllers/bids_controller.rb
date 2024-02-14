# frozen_string_literal: true

class BidsController < ApplicationController
  def create
    @product = Product.find(params[:product_id])
    @bid = @product.bids.build(bid_params)
    @bid.user = current_user
    if @bid.save
      ProductChannel.broadcast_to(@product, { action: 'new_bid', bid: @bid, email: @bid.user.email })
      head :ok
    else
      redirect_to @product, alert: 'Error placing bid.'
    end
  end

  private

  def bid_params
    params.require(:bid).permit(:price)
  end
end
