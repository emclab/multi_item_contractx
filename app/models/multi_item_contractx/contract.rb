module MultiItemContractx
  class Contract < ActiveRecord::Base
    attr_accessor :void_noupdate, :last_updated_by_name, :submited_by_name, :signed_by_name, :signed_noupdate, :contract_on_file_noupdate, :sales_name
    attr_accessible :name, :contract_date, :contract_num, :contract_on_file, :contract_info, :contract_total, :customer_id, :customer_signed_by, :sales_id, :tax, :customer_po,
                    :other_charge, :paid_out, :payment_agreement, :payment_term, :sign_date, :signed, :signed_by_id, :void, :contract_items_attributes, :wf_state, :customer_name_autocomplete,
                    :as => :role_new
    attr_accessible :name, :contract_date, :contract_num, :contract_on_file, :contract_info, :contract_total, :customer_id, :customer_signed_by, :tax, :customer_po, :sales_id,
                    :other_charge, :paid_out, :payment_agreement, :payment_term, :sign_date, :signed, :signed_by_id,  :void, :contract_items_attributes, :customer_name_autocomplete,
                    :void_noupdate, :last_updated_by_name, :submited_by_name, :signed_by_name, :signed_noupdate, :contract_on_file_noupdate, :wf_state, :sales_name,
                    :as => :role_update
    
    attr_accessor :start_date_s, :end_date_s, :customer_id_s, :zone_id_s, :paid_out_s, :sales_id_s, :contract_num_s, :wf_state_s, :customer_po_s,
                  :signed_s, :signed_by_id_s, :sign_date_s, :contract_on_file_s, :time_frame_s, :item_id_s, :name_s

    attr_accessible :start_date_s, :end_date_s, :customer_id_s, :zone_id_s, :paid_out_s, :sales_id_s, :payment_agreement_s, :contract_num_s, :customer_po_s,
                  :signed_s, :signed_by_id_s, :sign_date_s, :sales_id_s, :contract_on_file_s, :time_frame_s, :wf_state_s, :item_id_s, :name_s,
                  :as => :role_search_stats
                                  
    belongs_to :customer, :class_name => MultiItemContractx.customer_class.to_s
    belongs_to :signed_by, :class_name => 'Authentify::User'
    belongs_to :sales, :class_name => 'Authentify::User'
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :category, :class_name => 'Commonx::MiscDefinition'
    has_many :contract_items, :class_name => MultiItemContractx::ContractItem
    accepts_nested_attributes_for :contract_items, :allow_destroy => true

    validates :contract_total, :customer_id, :sales_id, :presence => true,
                               :numericality => {:greater_than => 0}
    validates :contract_date, :name, :presence => true
    validates :payment_term, :numericality => {:greater_than_or_equal_to => 0, :only_integer => true}, :if => 'payment_term.present?'
    validates :signed_by_id, :numericality => {:greater_than => 0, :only_integer => true}, :if => 'signed_by_id.present?'
    validates :category_id, :numericality => {:greater_than => 0, :only_integer => true}, :if => 'category_id.present?'
    validates :contract_num, :uniqueness => {:case_sensitive => false}, :if => 'contract_num.present?'
    validate :dynamic_validate 
    
    def dynamic_validate
      wf = Authentify::AuthentifyUtility.find_config_const('dynamic_validate', 'multi_item_contractx_contracts')
      eval(wf) if wf.present?
    end
    
    def customer_name_autocomplete
      self.customer.try(:name)
    end

    def customer_name_autocomplete=(name)
      self.customer = MultiItemContractx.customer_class.find_by_name(name) if name.present?
    end     
  end
end
