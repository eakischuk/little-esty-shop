FactoryBot.define do
  factory :bulk_discount do
    percentage { 15 }
    quantity_threshold { 5 }
    merchant
  end
end
