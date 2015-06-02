module MultiItemContractx
  class ContractItem < ActiveRecord::Base
    #attr_accessible :contract_id, :contract_item_id, :as => :role_new
    #attr_accessible :contract_id, :contract_item_id, :as => :role_update
    
    belongs_to :contract_item, :class_name => MultiItemContractx.contract_item_class.to_s
    
    validates :contract_item_id, :contract_id, :presence => true, :numericality => {:greater_than => 0}
    validates :contract_item_id, :uniqueness => {:scope => :contract_id, :message => 'Duplicate Item'}
  end
end
