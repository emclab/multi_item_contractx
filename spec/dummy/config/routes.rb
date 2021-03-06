Rails.application.routes.draw do

  mount MultiItemContractx::Engine => "/multi_item_contractx"
  mount Commonx::Engine => "/commonx"
  mount Authentify::Engine => '/authentify'
  mount Kustomerx::Engine => '/kustomerx'
  mount Searchx::Engine => '/searchx'
  mount AdResourceOrderx::Engine => '/order'
  mount StateMachineLogx::Engine => '/sm_log'
  mount BizWorkflowx::Engine => '/biz_wf'
  mount AdResourcex::Engine => '/resource'
  mount Supplierx::Engine => '/supplier'
  
  resource :session
  
  root :to => "authentify::sessions#new"
  match '/signin',  :to => 'authentify::sessions#new'
  match '/signout', :to => 'authentify::sessions#destroy'
  match '/user_menus', :to => 'user_menus#index'
  match '/view_handler', :to => 'authentify::application#view_handler'
end
