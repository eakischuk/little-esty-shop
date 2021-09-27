require 'rails_helper'

RSpec.describe 'bulk discounts index page', type: :feature do
  before(:each) do
    @merchant = create(:merchant)
    @merchant_2 = create(:merchant, name: 'Sals Salsa')

    @bulk_discount_1 = create(:bulk_discount, merchant: @merchant) # 15% for 5 items
    @bulk_discount_2 = create(:bulk_discount, merchant: @merchant, percentage: 20, quantity_threshold: 10)
    @bulk_discount_3 = create(:bulk_discount, merchant: @merchant_2, percentage: 10, quantity_threshold: 15)

    visit merchant_bulk_discounts_path(merchant_id: @merchant)
  end

  it 'displays discounts for correct merchant' do
    within("#discounts-#{@bulk_discount_1.id}") do
      expect(page).to have_content(@bulk_discount_1.id)
    end
    within("#discounts-#{@bulk_discount_1.id}-attributes") do
      expect(page).to have_content(@bulk_discount_1.percentage)
      expect(page).to have_content(@bulk_discount_1.quantity_threshold)
    end
    within("#discounts-#{@bulk_discount_2.id}") do
      expect(page).to have_content(@bulk_discount_2.id)
    end
    within("#discounts-#{@bulk_discount_2.id}-attributes") do
      expect(page).to have_content(@bulk_discount_2.percentage)
      expect(page).to have_content(@bulk_discount_2.quantity_threshold)
    end
    expect(page).to_not have_content(@bulk_discount_3.id)
  end
end
