require 'spec_helper'

describe "LinkTests" do
  describe "GET /multi_item_contractx_link_tests" do
    mini_btn = 'btn btn-mini '
    ActionView::CompiledTemplates::BUTTONS_CLS =
        {'default' => 'btn',
         'mini-default' => mini_btn + 'btn',
         'action'       => 'btn btn-primary',
         'mini-action'  => mini_btn + 'btn btn-primary',
         'info'         => 'btn btn-info',
         'mini-info'    => mini_btn + 'btn btn-info',
         'success'      => 'btn btn-success',
         'mini-success' => mini_btn + 'btn btn-success',
         'warning'      => 'btn btn-warning',
         'mini-warning' => mini_btn + 'btn btn-warning',
         'danger'       => 'btn btn-danger',
         'mini-danger'  => mini_btn + 'btn btn-danger',
         'inverse'      => 'btn btn-inverse',
         'mini-inverse' => mini_btn + 'btn btn-inverse',
         'link'         => 'btn btn-link',
         'mini-link'    => mini_btn +  'btn btn-link'
        }
    before(:each) do
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
      
      ua1 = FactoryGirl.create(:user_access, :action => 'index', :resource => 'multi_item_contractx_contracts', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "MultiItemContractx::Contract.where(:void => false).order('created_at DESC')")
      ua1 = FactoryGirl.create(:user_access, :action => 'create', :resource => 'multi_item_contractx_contracts', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      ua1 = FactoryGirl.create(:user_access, :action => 'update', :resource => 'multi_item_contractx_contracts', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      ua1 = FactoryGirl.create(:user_access, :action => 'show', :resource => 'multi_item_contractx_contracts', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")      
      user_access = FactoryGirl.create(:user_access, :action => 'sales', :resource =>'multi_item_contractx_contracts', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'ad_resource_orderx_orders', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'create_multi_item_contract', :resource => 'commonx_logs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
                
      @cust = FactoryGirl.create(:kustomerx_customer, :name => 'customer1')
      @cust1 = FactoryGirl.create(:kustomerx_customer, :name => 'new', :short_name => 'new new')
      
      visit '/'
      #save_and_open_page
      fill_in "login", :with => @u.login
      fill_in "password", :with => @u.password
      click_button 'Login'
    end
    
    it "works! (now write some real specs)" do
      qs = FactoryGirl.create(:multi_item_contractx_contract, :void => false, :last_updated_by_id => @u.id, :customer_id => @cust.id)
      visit contracts_path
      save_and_open_page
      page.should have_content('Contracts')
      click_link(qs.id.to_s)
      save_and_open_page
      page.should have_content('Contract Info')
      click_link 'New Log'
      page.should have_content('Log')
      visit contracts_path
      #save_and_open_page
      click_link('Edit')
      #save_and_open_page
      page.should have_content('Edit Contract')
      fill_in 'contract_contract_info', :with => 'something'
      click_button 'Save'
      save_and_open_page
      #bad data
      visit contracts_path
      click_link('Edit')
      fill_in 'contract_contract_total', :with => 0
      click_button 'Save'
      save_and_open_page
      
      visit contracts_path()
      click_link('New Contract')
      page.should have_content('New Contract')
      select('customer1', :from => 'contract_customer_id')
      select('Test User', :from => 'contract_sales_id')
      fill_in 'contract_name', :with => 'a new contract'
      fill_in 'contract_contract_total', :with => 231
      fill_in 'contract_contract_date', :with => Date.today
      click_button 'Save'
      #save_and_open_page
      visit contracts_path
      page.should have_content('231')
      #bad data
      visit contracts_path()
      click_link('New Contract')
      page.should have_content('New Contract')
      fill_in 'contract_name', :with => 'a new contract - 2'
      select('customer1', :from => 'contract_customer_id')
      select('Test User', :from => 'contract_sales_id')
      fill_in 'contract_contract_total', :with => 230000
      fill_in 'contract_contract_date', :with => nil
      click_button 'Save'
      #save_and_open_page
      visit contracts_path
      page.should_not have_content('230000')
       
    end
  end
end
