Rails.application.routes.draw do
  devise_for :users, :controllers => { :registrations => "users/registrations" }
  resources :jobs do
    collection do
      get :search
      get :developer
      get :design
      get :product
    end

    resources :resumes
    member do
        post :add
        post :remove
    end
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
