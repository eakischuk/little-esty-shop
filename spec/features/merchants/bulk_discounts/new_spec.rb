require 'rails_helper'

RSpec.describe 'merchant bulk discount new page' do
  before(:each) do
    @merchant = create(:merchant)
    @bulk_discount_1 = create(:bulk_discount, merchant: @merchant) # 15% for 5 items
  end
  describe 'form display' do
    it 'has correct fields' do
      visit new_merchant_bulk_discount_path(@merchant.id)
      expect(page).to have_field('bulk_discount[percentage]')
      expect(page).to have_field('bulk_discount[quantity_threshold]')
      expect(page).to have_button("Create Bulk Discount")
    end
   end
  describe 'form behavior' do
    it 'creates new discount' do
      visit merchant_bulk_discounts_path(@merchant.id)
      expect(page).to have_content(@bulk_discount_1.id)
      expect(page).to_not have_content("Percentage: 20")
      expect(page).to_not have_content("Quantity Threshold: 10")
      click_on "Create New Discount"

      fill_in('bulk_discount[percentage]', with: 20)
      fill_in('bulk_discount[quantity_threshold]', with: 10)
      click_on "Create Bulk Discount"

      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant.id))
      within('#flash-message') do
        expect(page).to have_content("Success, new discount")
      end
      expect(page).to have_content("Percentage: 20")
      expect(page).to have_content("Quantity Threshold: 10")
    end

    it 'requires all fields' do
      visit new_merchant_bulk_discount_path(@merchant.id)
      click_on "Create Bulk Discount"

      expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant.id))
      within('#flash-message') do
        expect(page).to have_content('Discount not created')
      end
    end
  end
end
