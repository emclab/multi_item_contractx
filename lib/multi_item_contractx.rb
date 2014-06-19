require "multi_item_contractx/engine"

module MultiItemContractx
  mattr_accessor :customer_class, :contract_item_class
  
  def self.customer_class
    @@customer_class.constantize
  end
  
  def self.item_class
    @@contract_item_class.constantize
  end
end
