Rails.application.routes.draw do
  get 'search/search'
  devise_for :users, skip: [:registrations]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root to: redirect("/lists")

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  resources :movies
  resources :bookmarks, only: [:destroy]
  resources :lists do
    resources :bookmarks, only: [:new, :create]
    get "search", to: "search#search", as: :search_items
  end

  resources :series do
    resources :seasons, only: [:show] do
      resources :episodes, only: [:show]
    end
  end
end
