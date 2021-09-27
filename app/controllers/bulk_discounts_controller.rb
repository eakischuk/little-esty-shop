class BulkDiscountsController < ApplicationController
  def edit
    @discount = BulkDiscount.find(params[:id])
  end

  def update
    discount = BulkDiscount.find(params[:id])
    discount.update(discount_params)
    flash[:success] = "##{discount.id} has been successfully updated!"
    redirect_to merchant_bulk_discount_path(discount.merchant.id, discount.id)
  end

  def destroy
    discount = BulkDiscount.find(params[:id])
    discount.destroy
    redirect_to merchant_bulk_discounts_path(params[:merchant_id])
  end

private
  def discount_params
    params.require(:bulk_discount).permit(:percentage, :quantity_threshold)
  end
end
