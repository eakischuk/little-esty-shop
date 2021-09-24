require 'rails_helper'

RSpec.describe 'Merchant Dashboard page' do
  context 'when i visit my merchant dashboard' do
    before(:each) do
      @sprouts = create(:merchant)
      visit "/merchants/#{@sprouts.id}/dashboard"
    end

    it 'shows the name of my merchant' do
      expect(page).to have_content('Sprouts')
    end

    it 'has a link to my items page' do
      click_link('My Items')
      expect(current_path).to eq("/merchants/#{@sprouts.id}/items")
    end

    it 'has a link to my invoices index' do
      click_link('My Invoices') # needs a flash "there are no invoices" if there are none
      expect(current_path).to eq("/merchants/#{@sprouts.id}/invoices")
    end
  end

  context 'top 5 customers' do
    before(:each) do
      @merchant = create(:merchant)
      @item     = create(:item, merchant_id: @merchant.id)

      # 6 successful transactions, 1 failed
      @customer_1    = create(:customer)
      @invoice_1     = create(:invoice, customer_id: @customer_1.id)
      @invoice_item_1  = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_1.id)
      @transaction_1 = create(:transaction, invoice_id: @invoice_1.id, result: 'success')
      @transaction_2 = create(:transaction, invoice_id: @invoice_1.id, result: 'success')
      @transaction_3 = create(:transaction, invoice_id: @invoice_1.id, result: 'success')
      @transaction_4 = create(:transaction, invoice_id: @invoice_1.id, result: 'success')
      @transaction_5 = create(:transaction, invoice_id: @invoice_1.id, result: 'success')
      @transaction_6 = create(:transaction, invoice_id: @invoice_1.id, result: 'success')
      # failed
      @transaction_7 = create(:transaction, invoice_id: @invoice_1.id)

      # 5 successes
      @customer_2    = create(:customer)
      @invoice_2     = create(:invoice, customer_id: @customer_2.id)
      @invoice_item_2  = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_2.id)
      @transaction_8 = create(:transaction, invoice_id: @invoice_2.id, result: 'success')
      @transaction_9 = create(:transaction, invoice_id: @invoice_2.id, result: 'success')
      @transaction_10 = create(:transaction, invoice_id: @invoice_2.id, result: 'success')
      @transaction_11 = create(:transaction, invoice_id: @invoice_2.id, result: 'success')
      @transaction_12 = create(:transaction, invoice_id: @invoice_2.id, result: 'success')

      # 4 successes
      @customer_3    = create(:customer)
      @invoice_3     = create(:invoice, customer_id: @customer_3.id)
      @invoice_item_3  = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_3.id)
      @transaction_13 = create(:transaction, invoice_id: @invoice_3.id, result: 'success')
      @transaction_14 = create(:transaction, invoice_id: @invoice_3.id, result: 'success')
      @transaction_15 = create(:transaction, invoice_id: @invoice_3.id, result: 'success')
      @transaction_16 = create(:transaction, invoice_id: @invoice_3.id, result: 'success')

      # 3 successes
      @customer_4    = create(:customer)
      @invoice_4     = create(:invoice, customer_id: @customer_4.id)
      @invoice_item_4  = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_4.id)
      @transaction_17 = create(:transaction, invoice_id: @invoice_4.id, result: 'success')
      @transaction_18 = create(:transaction, invoice_id: @invoice_4.id, result: 'success')
      @transaction_19 = create(:transaction, invoice_id: @invoice_4.id, result: 'success')

      # 2 successes
      @customer_5    = create(:customer)
      @invoice_5     = create(:invoice, customer_id: @customer_5.id)
      @invoice_item_5  = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_5.id)
      @transaction_20 = create(:transaction, invoice_id: @invoice_5.id, result: 'success')
      @transaction_21 = create(:transaction, invoice_id: @invoice_5.id, result: 'success')

      @customer_6    = create(:customer, first_name: 'Jill')
      @invoice_6     = create(:invoice, customer_id: @customer_6.id)
      @invoice_item_6  = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_6.id)
      @transaction_1 = create(:transaction, invoice_id: @invoice_6.id, result: 'success')


      @merchant_2 = create(:merchant)
      @item_2     = create(:item, merchant_id: @merchant_2.id)

      @customer_7    = create(:customer)
      @invoice_7     = create(:invoice, customer_id: @customer_7.id)
      @invoice_item_7 = create(:invoice_item, item_id: @item_2.id, invoice_id: @invoice_7.id)

      visit "/merchants/#{@merchant.id}/dashboard"
    end

    it 'has the top 5 customers (most successful transactions)' do
      within '#favorite-customers' do
        expect(page).to     have_content(@customer_1.full_name)
        expect(page).to     have_content(@customer_2.full_name)
        expect(page).to     have_content(@customer_3.full_name)
        expect(page).to     have_content(@customer_4.full_name)
        expect(page).to     have_content(@customer_5.full_name)
        expect(page).to_not have_content(@customer_6.full_name)
      end
    end

    it 'has the number of successful transactions for top 5' do
      within "#customer-#{@customer_1.id}" do
        expect(page).to have_content('6 purchases')
      end
    end
  end

  context 'items ready to ship' do
    before(:each) do
      @merchant    = create(:merchant)

      @good_item_1 = create(:item, merchant_id: @merchant.id)
      @g_in_item_1 = create(:invoice_item, item_id: @good_item_1.id)
      @g_in_item_2 = create(:invoice_item, item_id: @good_item_1.id)

      @good_item_3 = create(:item, merchant_id: @merchant.id, name: 'pickles')
      @g_in_item_3 = create(:invoice_item, item_id: @good_item_3.id, status: 1)

      @good_item_4 = create(:item, merchant_id: @merchant.id, name: 'biscuits')
      @g_in_item_4 = create(:invoice_item, item_id: @good_item_4.id, status: 1)

      @bad_item_1  = create(:item, merchant_id: @merchant.id, name: 'candy')
      @b_in_item_1 = create(:invoice_item, item_id: @bad_item_1.id, status: 2)
      @bad_item_2  = create(:item, merchant_id: @merchant.id, name: 'walnuts')
      @b_in_item_2 = create(:invoice_item, item_id: @bad_item_2.id, status: 3)

      @discount_1 = create(:bulk_discount)
      @discount_2 = create(:bulk_discount)

      visit "/merchants/#{@merchant.id}/dashboard"
    end

    it 'has a section for items that are not shipped or unknown' do
      within '#items-ready' do
        expect(page).to     have_content(@good_item_1.name)
        expect(page).to     have_content(@good_item_3.name)
        expect(page).to     have_content(@good_item_4.name)

        expect(page).to_not have_content(@bad_item_1.name)
        expect(page).to_not have_content(@bad_item_2.name)
      end
    end

    it 'has each item invoice id' do
      within "#item-#{@g_in_item_1.invoice_id}" do
        expect(page).to have_content("Invoice ##{@g_in_item_1.invoice_id}")
      end
    end

    it 'links to the invoice show page from each invoice id' do
      click_link("Invoice ##{@g_in_item_1.invoice_id}")
      expect(current_path).to eq("/merchants/#{@merchant.id}/invoices/#{@g_in_item_1.invoice_id}")
    end

    it 'displays the invoice created date' do
      expected = @good_item_1.created_at.strftime("%A, %B %d, %Y")
      within "#item-#{@g_in_item_1.invoice_id}" do
        expect(page).to have_content(expected)
      end
    end

    it 'lists items oldest to newest' do
      expect(@good_item_1.name).to appear_before(@good_item_3.name)
      expect(@good_item_3.name).to appear_before(@good_item_4.name)
    end

    it 'has a link to view all my discounts' do
      expect(page).to have_link('All Discounts')
      click_link('All Discounts')
    end
  end
end
