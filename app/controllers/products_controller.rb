# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :require_login

  def index
    @products = if buyer?
                  Product.all
                else
                  current_user.products.all
                end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @products }
    end
  end

  def show
    @product = Product.find(params[:id])
  end

  def select_bid
    @product = Product.find(params[:id])
    if seller? && @product.user_id == current_user.id
      @product.update(selected_bid_id: params[:bid_id])
      ProductChannel.broadcast_to(@product,
                                  { action: 'bid_selected', selected_bid_id: @product.selected_bid_id, email: @product.selected_bid.user.email,
                                    price: @product.selected_bid.price })
      head :ok
    else
      flash[:alert] = 'You are not authorized to perform this action.'
      redirect_to @product
    end
  end

  private

  def require_login
    return if logged_in?

    respond_to do |format|
      format.html { redirect_to root_url, alert: 'You must be logged in to access this page.' }
      format.json { render json: { error: 'You must be logged in to access this page.' }, status: :unauthorized }
    end
  end
end
