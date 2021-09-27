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
  describe 'display' do
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
  describe 'links' do
    it 'links to each discount show page' do
      within("#discounts-#{@bulk_discount_1.id}") do
        expect(page).to have_link("#{@bulk_discount_1.id}")
      end
      within("#discounts-#{@bulk_discount_2.id}") do
        expect(page).to have_link("#{@bulk_discount_2.id}")
        click_on "#{@bulk_discount_2.id}"
      end
      expect(current_path).to eq(merchant_bulk_discount_path(@merchant.id, @bulk_discount_2.id))
    end

    it 'link to create new discount' do
      expect(page).to have_link("Create New Discount")
      click_on "Create New Discount"
      expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant.id))
    end

    it 'has links to delete each discount' do
      within("#discounts-#{@bulk_discount_1.id}") do
        expect(page).to have_button("Delete")
      end
      within("#discounts-#{@bulk_discount_2.id}") do
        expect(page).to have_button("Delete")
        click_on "Delete"
      end

      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant))
    end
  end
end
