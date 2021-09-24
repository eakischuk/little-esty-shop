class Invoice < ApplicationRecord
  enum status: [:cancelled, 'in progress', :completed, :unknown]

  belongs_to :customer
  has_many   :transactions,  dependent: :destroy
  has_many   :invoice_items, dependent: :destroy
  has_many   :items, through: :invoice_items

  def invoice_items_by_merchant_id(merchant_id)
    invoice_items.joins(:item).where(items: {merchant_id: merchant_id})
  end

  def formatted_date
    created_at.strftime("%A, %B %d, %Y")
  end

  def customer_name
    customer.full_name
  end

  def paid?
    transactions.where('result = ?', 'success').length > 0
  end

  def total_revenue
    if paid?
      invoice_items.sum("quantity * unit_price")
    else
      0
    end
  end

  def self.incomplete
    joins(:invoice_items)
    .where.not('invoice_items.status = ?', 2)
    .distinct
    .order(:created_at)
  end

  def total_revenue_by_merchant_id(merchant_id)
    if paid?
      invoice_items_by_merchant_id(merchant_id).sum("invoice_items.quantity * invoice_items.unit_price")
    else
      0
    end
  end
end

# .joins(:invoice_items).where.not('invoice_items.status = ?', 3)
