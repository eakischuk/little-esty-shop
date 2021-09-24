class BulkDiscountsController < ApplicationController
  def index
    @discounts = BulkDiscount.all
  end

  def show
    @discount = BulkDiscount.find(params[:id])
  end
end