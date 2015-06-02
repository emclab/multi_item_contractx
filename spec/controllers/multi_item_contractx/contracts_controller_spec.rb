require 'rails_helper'

module MultiItemContractx
  RSpec.describe ContractsController, type: :controller do
    routes {MultiItemContractx::Engine.routes}
    before(:each) do
      #expect(controller).to receive(:require_signin)
      expect(controller).to receive(:require_employee)
    end
    before(:each) do
      piece_code = "@contract_item = return_contract_item
                    @contract_item = @contract_item.where('ad_resource_orderx_orders.customer_id = ?', @contract.customer_id) if @contract_item && @contract && @contract.customer_id.present?"
      FactoryGirl.create(:engine_config, :engine_name => 'multi_item_contractx', :engine_version => nil, :argument_name => 'contract_ajax_callback', :argument_value => piece_code)
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
      @cust = FactoryGirl.create(:kustomerx_customer)
      @cust1 = FactoryGirl.create(:kustomerx_customer, :name => 'new', :short_name => 'new new')
      @order = FactoryGirl.create(:ad_resource_orderx_order, :order_date => Date.today)
      
      session[:user_role_ids] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id).user_role_ids
    end
      
    render_views
  
    describe "GET 'index'" do
      it "returns all contracts for regular user" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'multi_item_contractx_contracts', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "MultiItemContractx::Contract.where(:void => false).order('created_at')")
        session[:employee] = true
        session[:user_id] = @u.id
        qs = FactoryGirl.create(:multi_item_contractx_contract, :void => false, :last_updated_by_id => @u.id, :customer_id => @cust.id, :sales_id => @u.id)
        qs1 = FactoryGirl.create(:multi_item_contractx_contract, :void => false, :last_updated_by_id => @u.id, :contract_num => nil, :sales_id => @u.id)
        get 'index' 
        expect(assigns(:contracts)).to match_array([qs, qs1])       
      end
      
      it "should return contracts for the customer" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'multi_item_contractx_contracts', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "MultiItemContractx::Contract.where(:void => false).order('created_at')")
        session[:employee] = true
        session[:user_id] = @u.id
        qs = FactoryGirl.create(:multi_item_contractx_contract, :void => false, :last_updated_by_id => @u.id, :customer_id => @cust.id, :sales_id => @u.id)
        qs1 = FactoryGirl.create(:multi_item_contractx_contract, :void => true, :last_updated_by_id => @u.id, :customer_id => @cust1.id, :contract_num => nil, :sales_id => @u.id)
        get 'index' , {:customer_id => @cust.id}
        expect(assigns(:contracts)).to eq([qs])
      end
      
      it "should return contracts for the sales" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'multi_item_contractx_contracts', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "MultiItemContractx::Contract.where(:void => false).order('created_at')")
        session[:employee] = true
        session[:user_id] = @u.id
        qs = FactoryGirl.create(:multi_item_contractx_contract, :void => false, :last_updated_by_id => @u.id, :customer_id => @cust.id, :sales_id => @u.id + 1)
        qs1 = FactoryGirl.create(:multi_item_contractx_contract, :void => false, :last_updated_by_id => @u.id, :contract_num => nil, :sales_id => @u.id)
        get 'index' , {:sales_id => @u.id}
        expect(assigns(:contracts)).to eq([qs1])
      end
    end
  
    describe "GET 'new'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'multi_item_contractx_contracts', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'ad_resource_orderx_orders', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        get 'new' , {:customer_id => @cust.id}
        expect(response).to be_success
      end
      
    end
  
    describe "GET 'create'" do
      it "redirect for a successful creation" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'multi_item_contractx_contracts', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        qs = FactoryGirl.attributes_for(:multi_item_contractx_contract, :customer_id => @cust.id)
        get 'create' , { :contract => qs, :customer_id => @cust.id}
        expect(response).to redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      end
      
      it "should render 'new' if data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'multi_item_contractx_contracts', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'ad_resource_orderx_orders', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        qs = FactoryGirl.attributes_for(:multi_item_contractx_contract, :contract_total => nil)
        get 'create' , {:customer_id => @cust.id, :contract => qs}
        expect(response).to render_template("new")
      end
    end
  
    describe "GET 'edit'" do
      
      it "returns http success for edit" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'multi_item_contractx_contracts', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        qs = FactoryGirl.create(:multi_item_contractx_contract, :customer_id => @cust.id)
        get 'edit' , {:customer_id => @cust.id, :id => qs.id}
        expect(response).to be_success
      end
      
    end
  
    describe "GET 'update'" do
      
      it "redirect if success" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'multi_item_contractx_contracts', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        qs = FactoryGirl.create(:multi_item_contractx_contract)
        get 'update' , {:customer_id => @cust.id, :id => qs.id, :contract => {:contract_on_file => true}}
        expect(response).to redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      end
      
      it "should render 'edit' if data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'multi_item_contractx_contracts', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        qs = FactoryGirl.create(:multi_item_contractx_contract)
        get 'update' , {:customer_id => @cust.id, :id => qs.id, :contract => {:contract_total => nil}}
        expect(response).to render_template("edit")
      end
    end
  
    describe "GET 'show'" do
      
      it "should show" do
        user_access = FactoryGirl.create(:user_access, :action => 'show', :resource => 'multi_item_contractx_contracts', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        o = FactoryGirl.create(:ad_resource_orderx_order, :customer_po => 'new new')
        ci = FactoryGirl.create(:multi_item_contractx_contract_item, :contract_item_id => o.id)
        qs = FactoryGirl.create(:multi_item_contractx_contract, :contract_items => [ci], :customer_id => @cust.id)
        get 'show' , {:customer_id => @cust.id, :id => qs.id}
        expect(response).to be_success
      end
    end
  
  end
end
