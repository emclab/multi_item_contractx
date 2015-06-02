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
  
  #resource :session
  
  root :to => "authentify/sessions#new"
  get '/signin',  :to => 'authentify/sessions#new'
  get '/signout', :to => 'authentify/sessions#destroy'
  get '/user_menus', :to => 'user_menus#index'
  get '/view_handler', :to => 'authentify/application#view_handler'
end
