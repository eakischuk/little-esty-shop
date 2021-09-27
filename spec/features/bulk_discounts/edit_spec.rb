require 'rails_helper'

RSpec.describe 'bulk discount edit page' do
  before(:each) do
    @merchant = create(:merchant)
    @merchant_2 = create(:merchant, name: 'Sals Salsa')

    @bulk_discount_1 = create(:bulk_discount, merchant: @merchant) # 15% for 5 items
    @bulk_discount_2 = create(:bulk_discount, merchant: @merchant, percentage: 20, quantity_threshold: 10)
    @bulk_discount_3 = create(:bulk_discount, merchant: @merchant_2, percentage: 10, quantity_threshold: 15)
  end
  describe 'edit form display' do
    it 'has pre-filled edit form' do
      visit edit_bulk_discount_path(@bulk_discount_1)
      expect(page).to have_content("Edit Discount ##{@bulk_discount_1.id}")
      expect(page).to have_field('bulk_discount[percentage]', with: 15)
      expect(page).to have_field('bulk_discount[quantity_threshold]', with: 5)
      expect(page).to have_button("Update Bulk Discount")
    end
  end
  describe 'edit form behavior' do
    it 'updates bulk discount' do
      visit edit_bulk_discount_path(@bulk_discount_1)
      click_on 'Update Bulk Discount'
      within('#flash-message') do
        expect(page).to have_content("##{@bulk_discount_1.id} has been successfully updated!")
      end
      expect(current_path).to eq(merchant_bulk_discount_path(@merchant.id, @bulk_discount_1.id))
      expect(page).to have_content(@bulk_discount_1.percentage)
      expect(page).to have_content(@bulk_discount_1.quantity_threshold)

      visit merchant_bulk_discount_path(@merchant.id, @bulk_discount_2.id)
      expect(page).to have_content(@bulk_discount_2.percentage)
      expect(page).to have_content(@bulk_discount_2.quantity_threshold)
      click_on "Edit Discount ##{@bulk_discount_2.id}"
      fill_in('bulk_discount[percentage]', with: 25)
      fill_in('bulk_discount[quantity_threshold]', with: 15)
      click_on 'Update Bulk Discount'
      within('#flash-message') do
        expect(page).to have_content("##{@bulk_discount_2.id} has been successfully updated!")
      end
      expect(current_path).to eq(merchant_bulk_discount_path(@merchant.id, @bulk_discount_2.id))
      expect(page).to have_content('Percentage: 25')
      expect(page).to have_content('Quantity Threshold: 15')
    end
  end
end
