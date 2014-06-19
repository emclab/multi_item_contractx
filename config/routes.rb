MultiItemContractx::Engine.routes.draw do
  resources :contracts do
    get :search
    get :search_results
  end

  root :to => 'contracts#index'
end
