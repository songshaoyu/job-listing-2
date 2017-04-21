Rails.application.routes.draw do
  devise_for :users
  resources :jobs do
    collection do
      get :search
      get :developer
      get :healthcare
      get :customer_service
      get :sales_marketing
      get :legal
      get :non_profit
      get :human_resource
      get :design
    end
    resources :resumes
  end
  root 'welcome#index'

  namespace :admin do
    resources :jobs do
    member do
      post :publish
      post :hide
    end

    resources :resumes
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
