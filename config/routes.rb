Rails.application.routes.draw do
  get "welcome/index"
  root to: "welcome#index"

  resources :articles, only: %i[index show destroy]
end
