class BulkDiscount < ApplicationRecord
  validates :percentage, presence: true
  validates :quantity_threshold, presence: true
  belongs_to :merchant

  def remaining_percentage
    ((100 - percentage).to_f / 100)
  end
end
