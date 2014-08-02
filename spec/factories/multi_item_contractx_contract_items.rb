# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :multi_item_contractx_contract_item, :class => 'MultiItemContractx::ContractItem' do
    contract_item_id 1
    contract_id 1
  end
end
