require_dependency "multi_item_contractx/application_controller"

module MultiItemContractx
  class ContractsController < ApplicationController
    before_filter :require_employee
    before_filter :load_parent_record
    helper_method :return_contract_item
    
    def index
      @title = 'Contracts'      
      @contracts = params[:multi_item_contractx_contracts][:model_ar_r]
      @contracts = @contracts.where(:customer_id => @customer.id) if @customer
      @contracts = @contracts.where(:sales_id => @sales_id) if @sales_id
      @contracts = @contracts.page(params[:page]).per_page(@max_pagination)
      @erb_code = find_config_const('contract_index_view', 'multi_item_contractx')
    end
  
    def new
      @title = 'New Contract'
      @contract = MultiItemContractx::Contract.new
      #eval(@piece_code) if @piece_code
      @contract_item = return_contract_item
      @erb_code = find_config_const('contract_new_view', 'multi_item_contractx')
      @erb_code_field = find_config_const('contract_new_view_field', 'multi_item_contractx')
    end
  
    def create
      @contract = MultiItemContractx::Contract.new(params[:contract], :as => :role_new)
      @contract.last_updated_by_id = session[:user_id]
      if @contract.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      else
        #eval(@piece_code) if @piece_code
        @contract_item = return_contract_item
        @erb_code = find_config_const('contract_new_view', 'multi_item_contractx')
        flash.now[:error] = t('Data Error. Not Saved!')
        render 'new'
      end
    end
  
    def edit
      @title = 'Edit Contract'
      @contract = MultiItemContractx::Contract.find_by_id(params[:id])
      #eval(@piece_code) if @piece_code
      @contract_item = return_contract_item
      @erb_code = find_config_const('contract_edit_view', 'multi_item_contractx')
      @erb_code_field = find_config_const('contract_new_view_field', 'multi_item_contractx')
    end
  
    def update
      @contract = MultiItemContractx::Contract.find_by_id(params[:id])
      @contract.last_updated_by_id = session[:user_id]
      if @contract.update_attributes(params[:contract], :as => :role_update)
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      else
        #eval(@piece_code) if @piece_code
        @contract_item = return_contract_item
        @erb_code = find_config_const('contract_edit_view', 'multi_item_contractx')
        flash.now[:error] = t('Data Error. Not Updated!')
        render 'edit'
      end
    end
  
    def show
      @title = 'Contract Info'
      @contract = MultiItemContractx::Contract.find_by_id(params[:id])
      @erb_code = find_config_const('contract_show_view', 'multi_item_contractx')
    end
    
    protected
    def load_parent_record
      @customer = MultiItemContractx.customer_class.find_by_id(params[:customer_id]) if params[:customer_id].present? 
      @customer = MultiItemContractx.customer_class.find_by_id(MultiItemContractx::Contract.find_by_id(params[:id]).customer_id) if params[:id].present? 
      @sales_id = params[:sales_id].to_i if params[:sales_id]
      @piece_code = find_config_const('contract_ajax_callback', 'multi_item_contractx')
      
    end
    
    def return_contract_item
      access_rights, models, has_record_access = Authentify::UserPrivilegeHelper.access_right_finder('index', MultiItemContractx.contract_item_class.to_s.underscore.pluralize, nil,nil,nil,nil, session[:user_privilege])
      return models
    end
  end
end
