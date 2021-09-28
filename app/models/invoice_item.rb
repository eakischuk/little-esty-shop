class InvoiceItem < ApplicationRecord
  enum status: [:packaged, :pending, :shipped, :unknown]

  belongs_to :item
  belongs_to :invoice
  has_one :merchant, through: :item
  has_many :bulk_discounts, through: :merchant

  def item_name
    item.name
  end

  def formatted_date
    invoice.formatted_date
  end

  def best_discount
    bulk_discounts.where('bulk_discounts.quantity_threshold <= ?', quantity)
    .order(percentage: :desc)
    .first
  end

  def total_revenue
    quantity * unit_price
  end

  def discounted_revenue
    if best_discount.nil?
      total_revenue
    else
      total_revenue * best_discount.remaining_percentage
    end
  end
end
