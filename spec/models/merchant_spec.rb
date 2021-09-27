require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many(:items).dependent(:destroy) }
    it { should have_many(:bulk_discounts).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe '#instance methods' do
    before(:each) do
      @merchant = create(:merchant)
      @merchant_2 = create(:merchant, name: "Jennys Jewels", status: 'Enabled')
      @disabled_item_1 = create(:item, merchant: @merchant)
      @disabled_item_2 = create(:item, merchant: @merchant)
      @enabled_item_1  = create(:item, merchant: @merchant, status: 'Enabled')
      @enabled_item_2  = create(:item, merchant: @merchant, status: 'Enabled')
    end

    describe 'enabled and disabled items' do
      it 'returns the merchants enabled items' do
        expect(@merchant.enabled_items).to eq([@enabled_item_1, @enabled_item_2])
      end

      it 'returns the merchants disabled items' do
        expect(@merchant.disabled_items).to eq([@disabled_item_1, @disabled_item_2])
      end
    end

    describe 'update_status' do
      it 'updates merchant status' do
        @merchant_2.update_status('Disabled')
        expect(@merchant_2.status).to eq('Disabled')
        @merchant.update_status('Enabled')
        expect(@merchant.status).to eq('Enabled')
      end
    end
  end

  describe '#class methods' do
    before(:each) do
      @transaction_s = create(:transaction, result: 'success')
      @merchant_1 = create(:merchant)
      @enabled_item_1  = create(:item, merchant: @merchant_1, status: 'Enabled')
      @invoice_1 = create(:invoice, created_at: '2012-03-25 09:54:09 UTC') # Sunday, March 25,2012
      @invoice_1.transactions << @transaction_s
      @invoice_1_1 = create(:invoice)
      @transaction_s_1 = create(:transaction, result: 'success')
      @invoice_1_1.transactions << @transaction_s_1
      @i_i_1 = create(:invoice_item, item: @enabled_item_1, unit_price: 2, quantity: 2, invoice: @invoice_1_1)
      @i_i_2 = create(:invoice_item, item: @enabled_item_1, unit_price: 2, quantity: 2, invoice: @invoice_1)
      @i_i_3 = create(:invoice_item, item: @enabled_item_1, unit_price: 2, quantity: 2, invoice: @invoice_1)

      @merchant_2 = create(:merchant, name: "Jennys Jewels", status: 'Enabled')
      @item_2 = create(:item, merchant: @merchant_2)
      @invoice_2 = create(:invoice)
      @transaction_s_2 = create(:transaction, result: 'success')
      @invoice_2.transactions << @transaction_s_2
      @invoice_3 = create(:invoice, created_at: '2012-03-24 15:54:10 UTC') # Saturday, March 25, 2012
      @transaction_s_3 = create(:transaction, result: 'success')
      @invoice_3.transactions << @transaction_s_3
      @i_i_4 = create(:invoice_item, item: @item_2, unit_price: 2, quantity: 1, invoice: @invoice_2)
      @i_i_5 = create(:invoice_item, item: @item_2, unit_price: 2, quantity: 1, invoice: @invoice_3)
      @i_i_6 = create(:invoice_item, item: @item_2, unit_price: 2, quantity: 1, invoice: @invoice_3)

      @merchant_3 = create(:merchant, name: "Super Sam", status: 'Enabled')
      @item_3 = create(:item, merchant: @merchant_3)
      @invoice_4 = create(:invoice)
      @transaction_s_4 = create(:transaction, result: 'success')
      @invoice_4.transactions << @transaction_s_4
      @invoice_5 = create(:invoice, created_at: '2012-03-21 13:54:10 UTC') # Wednesday, March 21, 2012
      @transaction_s_5 = create(:transaction, result: 'success')
      @invoice_5.transactions << @transaction_s_5
      @i_i_7 = create(:invoice_item, item: @item_3, unit_price: 2, quantity: 4, invoice: @invoice_4)
      @i_i_8 = create(:invoice_item, item: @item_3, unit_price: 2, quantity: 4, invoice: @invoice_5)
      @i_i_9 = create(:invoice_item, item: @item_3, unit_price: 2, quantity: 4, invoice: @invoice_5)

      @merchant_4 = create(:merchant, name: "Random Rogers", status: 'Enabled')
      @item_4 = create(:item, merchant: @merchant_4)
      @invoice_6 = create(:invoice)
      @transaction_s_6 = create(:transaction, result: 'success')
      @invoice_6.transactions << @transaction_s_6
      @invoice_7 = create(:invoice, created_at: '2012-03-10 10:54:10 UTC') # Saturday, March 10, 2012
      @transaction_s_7 = create(:transaction, result: 'success')
      @invoice_7.transactions << @transaction_s_7
      @i_i_10 = create(:invoice_item, item: @item_4, unit_price: 2, quantity: 3, invoice: @invoice_6)
      @i_i_11 = create(:invoice_item, item: @item_4, unit_price: 2, quantity: 3, invoice: @invoice_7)
      @i_i_12 = create(:invoice_item, item: @item_4, unit_price: 2, quantity: 3, invoice: @invoice_7)

      @merchant_5 = create(:merchant, name: "Caras Cupcakes", status: 'Enabled')
      @item_5 = create(:item, merchant: @merchant_5)
      @invoice_8 = create(:invoice)
      @transaction_s_8 = create(:transaction, result: 'success')
      @invoice_8.transactions << @transaction_s_8
      @invoice_9 = create(:invoice, created_at: '2012-03-13 07:54:10 UTC') # Tuesday, March 13, 2012
      @transaction_s_9 = create(:transaction, result: 'success')
      @invoice_9.transactions << @transaction_s_9
      @i_i_13 = create(:invoice_item, item: @item_5, unit_price: 2, quantity: 6, invoice: @invoice_8)
      @i_i_14 = create(:invoice_item, item: @item_5, unit_price: 2, quantity: 6, invoice: @invoice_9)
      @i_i_15 = create(:invoice_item, item: @item_5, unit_price: 2, quantity: 6, invoice: @invoice_9)

      @merchant_6 = create(:merchant, name: "Steve Sews", status: 'Enabled')
      @item_6 = create(:item, merchant: @merchant_6)
      @invoice_10 = create(:invoice)
      @transaction_s_10 = create(:transaction, result: 'success')
      @invoice_10.transactions << @transaction_s_10
      @invoice_11 = create(:invoice, created_at: '2012-03-22 08:54:10 UTC') # Thurday, March 22, 2012
      @transaction_s_11 = create(:transaction, result: 'success')
      @invoice_11.transactions << @transaction_s_11
      @i_i_16 = create(:invoice_item, item: @item_6, unit_price: 2, quantity: 5, invoice: @invoice_10)
      @i_i_17 = create(:invoice_item, item: @item_6, unit_price: 2, quantity: 5, invoice: @invoice_11)
      @i_i_18 = create(:invoice_item, item: @item_6, unit_price: 2, quantity: 5, invoice: @invoice_11)

      @merchant_7 = create(:merchant, name: "Vins Vinyl", status: 'Enabled')
      @item_7 = create(:item, merchant: @merchant_7)
      @invoice_12 = create(:invoice, created_at: '2012-03-27 07:54:11 UTC') # Tuesday, March 27, 2012
      @transaction_f = create(:transaction)
      @invoice_12.transactions << @transaction_f
      @invoice_13 = create(:invoice, created_at: '2012-03-22 08:54:10 UTC') # Thurday, March 22, 2012
      @transaction_f_13 = create(:transaction)
      @invoice_13.transactions << @transaction_f_13
      @invoice_14 = create(:invoice, created_at: '2012-03-13 07:54:10 UTC') # Tuesday, March 13, 2012
      @transaction_f_14 = create(:transaction)
      @invoice_14.transactions << @transaction_f_14
      @i_i_19 = create(:invoice_item, item: @item_7, unit_price: 2, quantity: 6, invoice: @invoice_12)
      @i_i_20 = create(:invoice_item, item: @item_7, unit_price: 2, quantity: 6, invoice: @invoice_13)
      @i_i_21 = create(:invoice_item, item: @item_7, unit_price: 2, quantity: 6, invoice: @invoice_14)
    end

    it '#enabled_merchants' do
      expect(Merchant.enabled_merchants).to eq([@merchant_2, @merchant_3, @merchant_4, @merchant_5, @merchant_6, @merchant_7])
    end

    it '#disabled_merchants' do
      expect(Merchant.disabled_merchants).to eq([@merchant_1])
    end

    it '#top_five' do
      expect(Merchant.top_five).to eq([@merchant_5, @merchant_6, @merchant_3, @merchant_4, @merchant_1])
    end

    describe 'top_five best_day instance method' do
      it '#best_day' do
        expect(@merchant_6.best_day).to eq(@invoice_11.created_at)
        expect(@merchant_1.best_day).to eq(@invoice_1.created_at)
      end
    end
  end

  describe '#favorite_customers' do
    before(:each) do
      @merchant = create(:merchant)
      @item     = create(:item, merchant_id: @merchant.id)

      # 5 successes
      @customer_2    = create(:customer)
      @invoice_2     = create(:invoice, customer_id: @customer_2.id)
      @invoice_item = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_2.id)
      @transaction_8 = create(:transaction, invoice_id: @invoice_2.id, result: 'success')
      @transaction_9 = create(:transaction, invoice_id: @invoice_2.id, result: 'success')
      @transaction_10 = create(:transaction, invoice_id: @invoice_2.id, result: 'success')
      @transaction_11 = create(:transaction, invoice_id: @invoice_2.id, result: 'success')
      @transaction_12 = create(:transaction, invoice_id: @invoice_2.id, result: 'success')

      # 4 successes
      @customer_3    = create(:customer)
      @invoice_3     = create(:invoice, customer_id: @customer_3.id)
      @invoice_item = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_3.id)
      @transaction_13 = create(:transaction, invoice_id: @invoice_3.id, result: 'success')
      @transaction_14 = create(:transaction, invoice_id: @invoice_3.id, result: 'success')
      @transaction_15 = create(:transaction, invoice_id: @invoice_3.id, result: 'success')
      @transaction_16 = create(:transaction, invoice_id: @invoice_3.id, result: 'success')

      # 3 successes
      @customer_4    = create(:customer)
      @invoice_4     = create(:invoice, customer_id: @customer_4.id)
      @invoice_item = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_4.id)
      @transaction_17 = create(:transaction, invoice_id: @invoice_4.id, result: 'success')
      @transaction_18 = create(:transaction, invoice_id: @invoice_4.id, result: 'success')
      @transaction_19 = create(:transaction, invoice_id: @invoice_4.id, result: 'success')

      # 2 successes
      @customer_5    = create(:customer)
      @invoice_5     = create(:invoice, customer_id: @customer_5.id)
      @invoice_item = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_5.id)
      @transaction_20 = create(:transaction, invoice_id: @invoice_5.id, result: 'success')
      @transaction_21 = create(:transaction, invoice_id: @invoice_5.id, result: 'success')

      @customer_6    = create(:customer, first_name: 'Jill')
      @invoice_6     = create(:invoice, customer_id: @customer_6.id)
      @invoice_item = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_6.id)
      @transaction_1 = create(:transaction, invoice_id: @invoice_6.id, result: 'success')

      @customer_1    = create(:customer)
      @invoice_1     = create(:invoice, customer_id: @customer_1.id)
      @invoice_item = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_1.id)
      @transaction_1 = create(:transaction, invoice_id: @invoice_1.id, result: 'success')
      @transaction_2 = create(:transaction, invoice_id: @invoice_1.id, result: 'success')
      @transaction_3 = create(:transaction, invoice_id: @invoice_1.id, result: 'success')
      @transaction_4 = create(:transaction, invoice_id: @invoice_1.id, result: 'success')
      @transaction_5 = create(:transaction, invoice_id: @invoice_1.id, result: 'success')
      @transaction_6 = create(:transaction, invoice_id: @invoice_1.id, result: 'success')

      # failed
      @transaction_7 = create(:transaction, invoice_id: @invoice_1.id)
    end

    it 'gives the top five for the merchant' do
      expect(@merchant.favorite_customers).to eq([@customer_1, @customer_2, @customer_3, @customer_4, @customer_5])
    end
  end

  context 'inv_items_ready' do
    before(:each) do
      @merchant    = create(:merchant)

      @good_item_1 = create(:item, merchant_id: @merchant.id)
      @g_in_item_1 = create(:invoice_item, item_id: @good_item_1.id)
      @good_item_2 = create(:item, merchant_id: @merchant.id, name: 'crackers')
      @g_in_item_2 = create(:invoice_item, item_id: @good_item_2.id)
      @good_item_3 = create(:item, merchant_id: @merchant.id, name: 'pickles')
      @g_in_item_3 = create(:invoice_item, item_id: @good_item_3.id, status: 1)
      @good_item_4 = create(:item, merchant_id: @merchant.id, name: 'biscuits')
      @g_in_item_4 = create(:invoice_item, item_id: @good_item_4.id, status: 1)

      @bad_item_1  = create(:item, merchant_id: @merchant.id, name: 'candy')
      @b_in_item_1 = create(:invoice_item, item_id: @bad_item_1.id, status: 2)
      @bad_item_2  = create(:item, merchant_id: @merchant.id, name: 'walnuts')
      @b_in_item_2 = create(:invoice_item, item_id: @bad_item_2.id, status: 3)
    end

    it 'returns invoice items that are not shipped or unknown' do
      expect(@merchant.inv_items_ready).to eq([@g_in_item_1, @g_in_item_2, @g_in_item_3, @g_in_item_4])
    end
  end

  context '5 most popular items' do
    before(:each) do
      @merchant_1 = create(:merchant)

      @item_1 = create(:item, merchant_id: @merchant_1.id) # 12345
      @item_2 = create(:item, merchant_id: @merchant_1.id, name: 'cake')
      @item_3 = create(:item, merchant_id: @merchant_1.id, name: 'crackers')
      @item_4 = create(:item, merchant_id: @merchant_1.id, name: 'candy')
      @item_5 = create(:item, merchant_id: @merchant_1.id, name: 'biscuits')
      @item_6 = create(:item, merchant_id: @merchant_1.id, name: 'crisps')
      @item_7 = create(:item, merchant_id: @merchant_1.id, name: 'pickles')
      @item_8 = create(:item, merchant_id: @merchant_1.id, name: 'pie')
      @item_9 = create(:item, merchant_id: @merchant_1.id, name: 'carrots')

      @inv_11 = create(:invoice)
      @inv_12 = create(:invoice)
      @inv_13 = create(:invoice)
      @inv_14 = create(:invoice)
      @inv_15 = create(:invoice)
      @inv_16 = create(:invoice)
      @inv_17 = create(:invoice)
      @inv_18 = create(:invoice)
      @inv_19 = create(:invoice)

      @ii_11 = create(:invoice_item, item_id: @item_1.id, invoice_id: @inv_11.id) #12345
      @ii_12 = create(:invoice_item, item_id: @item_2.id, invoice_id: @inv_12.id, unit_price: 22345)
      @ii_13 = create(:invoice_item, item_id: @item_3.id, invoice_id: @inv_13.id, unit_price: 32345)
      @ii_14 = create(:invoice_item, item_id: @item_4.id, invoice_id: @inv_14.id, unit_price: 52345)
      @ii_15 = create(:invoice_item, item_id: @item_5.id, invoice_id: @inv_15.id, unit_price: 92345)
      @ii_16 = create(:invoice_item, item_id: @item_6.id, invoice_id: @inv_16.id, unit_price: 42345)
      @ii_17 = create(:invoice_item, item_id: @item_7.id, invoice_id: @inv_17.id, unit_price: 72345)
      @ii_18 = create(:invoice_item, item_id: @item_8.id, invoice_id: @inv_18.id, unit_price: 82345)
      @ii_19 = create(:invoice_item, item_id: @item_9.id, invoice_id: @inv_19.id, unit_price: 62345)

      @tr_11 = create(:transaction, result: 'success', invoice_id: @inv_11.id)
      @tr_12 = create(:transaction, result: 'success', invoice_id: @inv_12.id)
      @tr_13 = create(:transaction, result: 'success', invoice_id: @inv_13.id)
      @tr_14 = create(:transaction, result: 'success', invoice_id: @inv_14.id)
      @tr_15 = create(:transaction, result: 'success', invoice_id: @inv_15.id)
      @tr_16 = create(:transaction, result: 'success', invoice_id: @inv_16.id)

      @tr_17 = create(:transaction, invoice_id: @inv_17.id) #failed
      @tr_18 = create(:transaction, invoice_id: @inv_18.id) #failed
      @tr_19 = create(:transaction, invoice_id: @inv_19.id) #failed

      @merchant_2 = create(:merchant)
      @item_22 = create(:item, merchant_id: @merchant_2.id, unit_price: 999999, name: 'waffles')
      @inv_22 = create(:invoice)
      @ii_22 = create(:invoice_item, item_id: @item_22.id, invoice_id: @inv_22.id)
      @tr_22 = create(:transaction, result: 'success', invoice_id: @inv_22.id)
    end

    it 'returns top five successful items by revenue' do
      expectation = [@item_5, @item_4, @item_6, @item_3, @item_2]
      expect(@merchant_1.top_items).to eq(expectation)
    end
  end
end


# describe 'disabled?' do
#   it 'returns true is disabled' do
#     expect(@merchant.disabled?).to eq(true)
#     expect(@merchant_2.disabled?).to eq(false)
#   end
# end
