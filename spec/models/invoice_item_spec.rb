require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  before(:each) do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant, name: 'Sals Salsa')

    @bulk_discount_1 = create(:bulk_discount, merchant: @merchant_1) # 15% for 5 items
    @bulk_discount_2 = create(:bulk_discount, merchant: @merchant_1, percentage: 20, quantity_threshold: 10)
    @bulk_discount_3 = create(:bulk_discount, merchant: @merchant_1, percentage: 25, quantity_threshold: 15)
    @bulk_discount_4 = create(:bulk_discount, merchant: @merchant_2, percentage: 10) # 15% for 5 items

    @item_1 = create(:item, merchant: @merchant_1) # cookies
    @item_2 = create(:item, merchant: @merchant_1, name: "crackers", status: "Enabled")
    @item_3 = create(:item, merchant: @merchant_1, name: "biscuits")
    @item_4 = create(:item, merchant: @merchant_1, name: "watermelon")
    @item_5 = create(:item, merchant: @merchant_2, name: "wafers", status: "Enabled")

    @invoice_1 = create(:invoice)
    @invoice_2 = create(:invoice)
    @invoice_3 = create(:invoice)

    @transaction_1 = create(:transaction, invoice: @invoice_1, result: 'success')
    @transaction_2 = create(:transaction, invoice: @invoice_2, result: 'success')
    @transaction_3 = create(:transaction, invoice: @invoice_3, result: 'success')

    @invoice_item_1 = create(:invoice_item, item: @item_1, invoice: @invoice_1, quantity: 10, unit_price: 2)
    @invoice_item_2 = create(:invoice_item, item: @item_3, invoice: @invoice_2, quantity: 5, unit_price: 2)
    @invoice_item_3 = create(:invoice_item, item: @item_5, invoice: @invoice_3, quantity: 10, unit_price: 2)
    @invoice_item_4 = create(:invoice_item, item: @item_2, invoice: @invoice_3, quantity: 3, unit_price: 2)
  end

  describe 'relationships' do
    it { should belong_to :item }
    it { should belong_to :invoice }
    it { should have_one(:merchant).through(:item) }
    it { should have_many(:bulk_discounts).through(:merchant) }
  end

  describe 'enums' do
    it { should define_enum_for(:status) }

    it 'can be packaged' do
      invoice_item = build(:invoice_item)
      expect(invoice_item.status).to eq('packaged')
    end

    it 'can be pending' do
      invoice_item = build(:invoice_item, status: 1)
      expect(invoice_item.status).to eq('pending')
    end

    it 'can be shipped' do
      invoice_item = build(:invoice_item, status: 2)
      expect(invoice_item.status).to eq('shipped')
    end

    it 'can be unknown' do
      invoice_item = build(:invoice_item, status: 3)
      expect(invoice_item.status).to eq('unknown')
    end
  end

  describe '#instance methods' do
    before(:each) do
      @item     = create(:item)
      @inv_item = create(:invoice_item, item_id: @item.id)
    end

    describe 'item_name' do
      it 'returns an item name' do
        expect(@inv_item.item_name).to eq(@item.name)
      end
    end

    describe '#formatted_date' do
      it 'returns the creation date of the invoice' do
        invoice = create(:invoice, created_at: 'Sun, 19 Sep 2021 11:11:11 UTC +00:00')
        invoice_item = create(:invoice_item, invoice_id: invoice.id)
        expect(invoice_item.formatted_date).to eq("Sunday, September 19, 2021")
      end
    end

    describe '#best_discount' do
      it 'returns the best discount for correct merchant' do
        expect(@invoice_item_1.best_discount).to eq(@bulk_discount_2)
        expect(@invoice_item_2.best_discount).to eq(@bulk_discount_1)
        expect(@invoice_item_3.best_discount).to eq(@bulk_discount_4)
      end
    end

    describe 'total revenue' do
      it 'returns revenue before discount' do
        expect(@invoice_item_1.total_revenue).to eq(20)
        expect(@invoice_item_4.total_revenue).to eq(6)
      end

      it 'returns discounted revenue' do
        expectation_1 = @invoice_item_1.total_revenue * @bulk_discount_2.remaining_percentage
        expect(@invoice_item_1.discounted_revenue).to eq(expectation_1)
        expect(@invoice_item_4.discounted_revenue).to eq(@invoice_item_4.total_revenue)
      end
    end
  end
end
