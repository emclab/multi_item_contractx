require 'spec_helper'

module MultiItemContractx
  describe Contract do
    it "should be OK" do
      p = FactoryGirl.build(:multi_item_contractx_contract)
      p.should be_valid
    end
    
    it "should reject nil contract total" do
      p = FactoryGirl.build(:multi_item_contractx_contract, :contract_total => nil)
      p.should_not be_valid
    end
    
    it "should reject nil name" do
      p = FactoryGirl.build(:multi_item_contractx_contract, :name => nil)
      p.should_not be_valid
    end
    
    it "should reject 0 contract total" do
      p = FactoryGirl.build(:multi_item_contractx_contract, :contract_total => 0)
      p.should_not be_valid
    end
    
    it "should reject nil customer_id" do
      p = FactoryGirl.build(:multi_item_contractx_contract, :customer_id => nil)
      p.should_not be_valid
    end
    
    it "should reject 0 customer_id" do
      p = FactoryGirl.build(:multi_item_contractx_contract, :customer_id => 0)
      p.should_not be_valid
    end
    
    it "should reject 0 category_id" do
      p = FactoryGirl.build(:multi_item_contractx_contract, :category_id => 0)
      p.should_not be_valid
    end
    
    it "should reject 0 signed_by_id" do
      p = FactoryGirl.build(:multi_item_contractx_contract, :signed_by_id => 0)
      p.should_not be_valid
    end
    
    it "should take 0 payment_term" do
      p = FactoryGirl.build(:multi_item_contractx_contract, :payment_term => 0)
      p.should be_valid
    end
    
    it "should take no char payment_term" do
      p = FactoryGirl.build(:multi_item_contractx_contract, :payment_term => "a")
      p.should_not be_valid
    end
    
    it "should take no integer payment_term" do
      p = FactoryGirl.build(:multi_item_contractx_contract, :payment_term => 0.6)
      p.should_not be_valid
    end
    
    it "should reject dup contract_num" do
      p = FactoryGirl.create(:multi_item_contractx_contract, :contract_num => 'abCD')
      p1 = FactoryGirl.build(:multi_item_contractx_contract, :contract_num => 'abcd')
      p1.should_not be_valid
    end
    
  end
end
