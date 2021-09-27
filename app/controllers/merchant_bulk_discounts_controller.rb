class MerchantBulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @discount = BulkDiscount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.new
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    discount = merchant.bulk_discounts.create(discount_params)
    if discount.save
      flash[:success] = "Success, new discount ##{discount.id} created!"
      redirect_to merchant_bulk_discounts_path(merchant.id)
    else
      flash[:error] = "Discount not created: #{error_message(discount.errors)}"
      redirect_to new_merchant_bulk_discount_path(merchant.id)
    end
  end

  private
    def discount_params
      params.require(:bulk_discount).permit(:percentage, :quantity_threshold)
    end
end
