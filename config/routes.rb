Rails.application.routes.draw do
  root to: "articles#index"
  get "welcome/index"

  resources :articles, only: %i[index show destroy]
  resources :tags, only: %i[index new create destroy]
end
