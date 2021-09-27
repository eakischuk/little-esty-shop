require 'rails_helper'

RSpec.describe 'merchant bulk discount show page' do
  before(:each) do
    @merchant = create(:merchant)
    @merchant_2 = create(:merchant, name: 'Sals Salsa')

    @bulk_discount_1 = create(:bulk_discount, merchant: @merchant) # 15% for 5 items
    @bulk_discount_2 = create(:bulk_discount, merchant: @merchant, percentage: 20, quantity_threshold: 10)
    @bulk_discount_3 = create(:bulk_discount, merchant: @merchant_2, percentage: 10, quantity_threshold: 15)
  end
  describe 'display' do
    it 'has discount attributes' do
      visit merchant_bulk_discount_path(@merchant, @bulk_discount_2)

      expect(page).to have_content(@bulk_discount_2.id)
      within('#discount-percentage') do
        expect(page).to have_content(@bulk_discount_2.percentage)
      end
      within('#discount-threshold') do
        expect(page).to have_content(@bulk_discount_2.quantity_threshold)
      end
    end
  end
end
