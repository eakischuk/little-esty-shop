require 'rails_helper'

RSpec.describe 'Merchant Item Show page' do
  context 'when i visit a merchant item show page' do
    before(:each) do
      @item = create(:item)

      visit "/merchants/#{@item.merchant.id}/items/#{@item.id}"
    end

    it 'displays the items Name, Description, Current Selling Price' do
      expect(page).to have_content("Name: #{@item.name}")
      expect(page).to have_content("Description: #{@item.description}")
      expect(page).to have_content("Current Selling Price: #{@item.unit_price}")
    end
  end
end
