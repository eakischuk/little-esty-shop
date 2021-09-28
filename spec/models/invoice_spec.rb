require 'rails_helper'

RSpec.describe Invoice, type: :model do
  before(:each) do
    @customer = create(:customer)

    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)

    @item_1 = create(:item, name: "Hi-Chew", merchant: @merchant_1)
    @item_2 = create(:item, merchant: @merchant_2)

    @bulk_discount_1 = create(:bulk_discount, merchant: @merchant_1) # 15% for 5 items
    @bulk_discount_2 = create(:bulk_discount, merchant: @merchant_1, percentage: 20, quantity_threshold: 10)
    @bulk_discount_3 = create(:bulk_discount, merchant: @merchant_1, percentage: 25, quantity_threshold: 15)
    @bulk_discount_4 = create(:bulk_discount, merchant: @merchant_2, percentage: 10) # for 5 items

    @invoice_1 = create(:invoice, created_at: '2012-03-20 09:54:09 UTC') # Sunday, March 25,2012
    @transaction_1 = create(:transaction, result: 'success')
    @invoice_1.transactions << @transaction_1
    @invoice_1_item_1 = create(:invoice_item, item: @item_1, quantity: 3, unit_price: 7, status: 1)
    @invoice_1_item_2 = create(:invoice_item, item: @item_2, quantity: 6, unit_price: 2, status: 2)
    @invoice_1.invoice_items << @invoice_1_item_1
    @invoice_1.invoice_items << @invoice_1_item_2

    @invoice_2 = create(:invoice, created_at: '2012-03-21 13:54:10 UTC') # Sunday, March 25,2012
    @transaction_2 = create(:transaction)
    @invoice_2.transactions << @transaction_2
    @invoice_2_item_1 = create(:invoice_item, item: @item_1, quantity: 5, unit_price: 7, status: 1)
    @invoice_2_item_2 = create(:invoice_item, item: @item_2, quantity: 2, unit_price: 6, status: 2)
    @invoice_2.invoice_items << @invoice_2_item_1
    @invoice_2.invoice_items << @invoice_2_item_2

    @invoice_3 = create(:invoice, status: 1, created_at: '2012-03-07 12:54:10 UTC')
    @transaction_3 = create(:transaction)
    @transaction_4 = create(:transaction, result: 'success')
    @invoice_3.transactions << @transaction_3
    @invoice_3.transactions << @transaction_4


    @invoice_4 = create(:invoice, created_at: 'Sun, 19 Sep 2021 11:11:11 UTC +00:00')
    @invoice_4_item_1 = create(:invoice_item, item: @item_1, quantity: 3, unit_price: 7, status: 2)
    @transaction_5 = create(:transaction, result: 'success')
    @invoice_4.transactions << @transaction_5
    @invoice_4.invoice_items << @invoice_4_item_1

    @invoice_5 = create(:invoice, customer_id: @customer.id, status: 2)
    @invoice_5_item_1 = create(:invoice_item, item: @item_1, quantity: 3, unit_price: 7, status: 2)
    @transaction_6 = create(:transaction, result: 'success')
    @invoice_5.transactions << @transaction_6
    @invoice_5.invoice_items << @invoice_5_item_1
  end

  describe 'relationships' do
    it { should belong_to(:customer) }
    it { should have_many(:transactions).dependent(:destroy) }
    it { should have_many(:invoice_items).dependent(:destroy) }
    it { should have_many(:items).through(:invoice_items) }
  end

  describe 'enums' do
    it { should define_enum_for(:status) }
  end

  describe 'invoice_items_by_merchant_id(merchant_id)' do
    it 'gets items by merchant_id' do
      merchant_1  = create(:merchant)
      item_1      = create(:item, merchant: merchant_1)
      item_2      = create(:item, merchant: merchant_1)
      item_3      = create(:item, merchant: merchant_1)

      merchant_2  = create(:merchant)
      item_4      = create(:item, merchant: merchant_2)
      item_5      = create(:item, merchant: merchant_2)
      item_6      = create(:item, merchant: merchant_2)

      invoice_1   = create(:invoice)
      invoice_2   = create(:invoice)

      inv_item_11 = create(:invoice_item, item: item_1, invoice: invoice_1)
      inv_item_21 = create(:invoice_item, item: item_2, invoice: invoice_1)
      inv_item_31 = create(:invoice_item, item: item_4, invoice: invoice_1)

      inv_item_32 = create(:invoice_item, item: item_3, invoice: invoice_2)
      inv_item_52 = create(:invoice_item, item: item_5, invoice: invoice_2)
      inv_item_62 = create(:invoice_item, item: item_6, invoice: invoice_2)
      inv_item_12 = create(:invoice_item, item: item_1, invoice: invoice_2)

      expect(invoice_1.invoice_items_by_merchant_id(merchant_1.id)).to eq([inv_item_11, inv_item_21])
      expect(invoice_2.invoice_items_by_merchant_id(merchant_2.id)).to eq([inv_item_52, inv_item_62])
    end
  end

  describe '#formatted_date' do
    it 'returns the date with weekday, month, date, year' do
      expect(@invoice_4.formatted_date).to eq("Sunday, September 19, 2021")
    end
  end

  describe '#customer_name' do
    it 'returns a customers full name' do
      expect(@invoice_5.customer_name).to eq "John Doe"
    end
  end

  describe '#total_revenue' do
    it 'returns total revenue for a paid invoice' do
      expect(@invoice_1.total_revenue).to eq(33)
      expect(@invoice_2.total_revenue).to eq(0)
    end

    it 'returns discounted revenue' do
      expectation_1 = @invoice_1_item_1.discounted_revenue + @invoice_1_item_2.discounted_revenue
      expect(@invoice_1.total_discounted_revenue).to eq(expectation_1)
      expect(@invoice_2.total_discounted_revenue).to eq(0)
    end
  end

  describe '#paid?' do
    it '#identifies invoices with successful transactions' do
      expect(@invoice_1.paid?).to eq(true)
      expect(@invoice_2.paid?).to eq(false)
      expect(@invoice_3.paid?).to eq(true)
    end
  end

  describe '#total_revenue' do
    it 'returns total revenue for a paid invoice' do
      expect(@invoice_1.total_revenue).to eq(33)
      expect(@invoice_2.total_revenue).to eq(0)
    end
  end

  describe '#paid?' do
    it '#identifies invoices with successful transactions' do
      expect(@invoice_1.paid?).to eq(true)
      expect(@invoice_2.paid?).to eq(false)
      expect(@invoice_3.paid?).to eq(true)
    end
  end

  describe '#incomplete' do
    it '#returns invoices with items not shipped' do
      expect(Invoice.incomplete).to eq([@invoice_1, @invoice_2])
    end
  end

  describe '#total_revenue_by_merchant_id(merchant_id)' do
    before(:each) do
      @merchant_1 = create(:merchant)
      @merchant_2 = create(:merchant)

      @item_1 = create(:item, merchant: @merchant_1)
      @item_2 = create(:item, merchant: @merchant_1)
      @item_3 = create(:item, merchant: @merchant_2)

      @bulk_discount_1 = create(:bulk_discount, merchant: @merchant_1) # 15% for 5 items
      @bulk_discount_2 = create(:bulk_discount, merchant: @merchant_1, percentage: 20, quantity_threshold: 10)
      @bulk_discount_3 = create(:bulk_discount, merchant: @merchant_1, percentage: 25, quantity_threshold: 15)
      @bulk_discount_4 = create(:bulk_discount, merchant: @merchant_2, percentage: 10) # for 5 items

      # 1 failure 1 success
      @invoice_1 = create(:invoice)
      @transaction_0 = create(:transaction, invoice: @invoice_1)
      @transaction_1 = create(:transaction, result: 'success', invoice: @invoice_1)

      @invoice_1_item_1 = create(:invoice_item, invoice: @invoice_1, item: @item_1, quantity: 10, unit_price: 7)
      @invoice_1_item_2 = create(:invoice_item, invoice: @invoice_1, item: @item_2, quantity: 2, unit_price: 6)
      # merchant 2s item
      @invoice_1_item_3 = create(:invoice_item, invoice: @invoice_1, item: @item_3, quantity: 2, unit_price: 6)

      # Only failure
      @invoice_2 = create(:invoice)
      @transaction_2 = create(:transaction, invoice: @invoice_2)

      @invoice_2_item_1 = create(:invoice_item, invoice: @invoice_2, item: @item_1, quantity: 3, unit_price: 7)
      @invoice_2_item_2 = create(:invoice_item, invoice: @invoice_2, item: @item_2, quantity: 2, unit_price: 6)
    end

    it 'returns total revenue for a paid invoice for a single merchant_id' do
      expect(@invoice_1.total_revenue_by_merchant_id(@merchant_1.id)).to eq(82)

      # no successful transactions
      expect(@invoice_2.total_revenue_by_merchant_id(@merchant_1.id)).to eq(0)
    end

    it 'returns total discounted revenue for a single merchant on a paid invoice' do
      expectation_1 = @invoice_1_item_2.total_revenue + @invoice_1_item_1.discounted_revenue

      expect(@invoice_1.discounted_revenue_by_merchant_id(@merchant_1.id)).to eq(expectation_1)
      expect(@invoice_2.discounted_revenue_by_merchant_id(@merchant_1.id)).to eq(0)
    end
  end
end
