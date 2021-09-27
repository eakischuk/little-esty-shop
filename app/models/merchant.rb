class Merchant < ApplicationRecord
  validates :name, presence: true
  has_many :items,   dependent: :destroy
  has_many :invoice_items, through: :items
  has_many :invoices,  through: :items
  has_many :customers, through: :invoices
  has_many :bulk_discounts, dependent: :destroy

  def favorite_customers
    customers.top_five_with_count
  end

  def enabled_items
    items.enabled
  end

  def disabled_items
    items.disabled
  end

  def inv_items_ready
    invoice_items.joins(:invoice).where(status: ['packaged', 'pending']).order('invoices.created_at')
  end

  def top_items
    items.top_items
  end

  def update_status(new_status)
    update(status: new_status)
  end

  def best_day
    invoices.joins(:transactions)
    .where('transactions.result = ?', 'success')
    .select("invoices.created_at, COUNT(*) AS successful_transactions")
    .group('invoices.created_at')
    .order('successful_transactions DESC, invoices.created_at DESC')
    .first.created_at
  end

  def self.enabled_merchants
    where status: 'Enabled'
  end

  def self.disabled_merchants
    where status: 'Disabled'
  end

  def self.top_five
    joins(items: {invoice_items: {invoice: :transactions}})
    .where('transactions.result = ?', "success")
    .select("merchants.*, SUM(invoice_items.unit_price * invoice_items.quantity) AS revenue")
    .group(:id)
    .order(revenue: :desc)
    .limit(5)
  end
end

# def invoice_items_by_invoice(invoice)
#   ii = invoice_items.where("invoice_id = ?", invoice.id)
# end

# def disabled?
#   status == 'Disabled'
# end
