Rails.application.routes.draw do
  root to: "articles#index"
  get "welcome/index"

  resources :articles, only: %i[index show destroy]
end
