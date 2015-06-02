require 'rails_helper'

module MultiItemContractx
  RSpec.describe Contract, type: :model do
    it "should be OK" do
      p = FactoryGirl.build(:multi_item_contractx_contract)
      expect(p).to be_valid
    end
    
    it "should reject nil contract total" do
      p = FactoryGirl.build(:multi_item_contractx_contract, :contract_total => nil)
      expect(p).not_to be_valid
    end
    
    it "should reject nil name" do
      p = FactoryGirl.build(:multi_item_contractx_contract, :name => nil)
      expect(p).not_to be_valid
    end
    
    it "should reject 0 contract total" do
      p = FactoryGirl.build(:multi_item_contractx_contract, :contract_total => 0)
      expect(p).not_to be_valid
    end

    it "should reject nil contract total" do
      p = FactoryGirl.build(:multi_item_contractx_contract, :contract_total => nil)
      expect(p).not_to be_valid
    end

    it "should reject nil customer_id" do
      p = FactoryGirl.build(:multi_item_contractx_contract, :customer_id => nil)
      expect(p).not_to be_valid
    end
    
    it "should reject 0 customer_id" do
      p = FactoryGirl.build(:multi_item_contractx_contract, :customer_id => 0)
      expect(p).not_to be_valid
    end
    
    it "should reject 0 category_id" do
      p = FactoryGirl.build(:multi_item_contractx_contract, :category_id => 0)
      expect(p).not_to be_valid
    end
    
    it "should reject 0 signed_by_id" do
      p = FactoryGirl.build(:multi_item_contractx_contract, :signed_by_id => 0)
      expect(p).not_to be_valid
    end
    
    it "should take 0 payment_term" do
      p = FactoryGirl.build(:multi_item_contractx_contract, :payment_term => 0)
      expect(p).to be_valid
    end
    
    it "should take no char payment_term" do
      p = FactoryGirl.build(:multi_item_contractx_contract, :payment_term => "a")
      expect(p).not_to be_valid
    end
    
    it "should take no integer payment_term" do
      p = FactoryGirl.build(:multi_item_contractx_contract, :payment_term => 0.6)
      expect(p).not_to be_valid
    end
    
    it "should reject dup contract_num" do
      p = FactoryGirl.create(:multi_item_contractx_contract, :contract_num => 'abCD')
      p1 = FactoryGirl.build(:multi_item_contractx_contract, :contract_num => 'abcd')
      expect(p1).not_to be_valid
    end
    
  end
end
