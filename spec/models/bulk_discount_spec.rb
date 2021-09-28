require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  before(:each) do
    @bulk_discount_1 = create(:bulk_discount) # 15% for 5 items
  end
  describe 'relationships' do
    it { should belong_to(:merchant) }
  end

  describe 'validations' do
    it { should validate_presence_of(:percentage) }
    it { should validate_presence_of(:quantity_threshold) }
  end

  describe 'instance methods' do
    it 'returns remaining_percentage after discount' do
      expect(@bulk_discount_1.remaining_percentage).to eq(0.85)
    end
  end
end
