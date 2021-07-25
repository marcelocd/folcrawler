Rails.application.routes.draw do
  root to: "articles#index"
  get "welcome/index"

  resources :articles, except: %i[new create show destroy] do
    collection do
      get 'scrape_articles'
    end
  end
  resources :tags, only: %i[index new create destroy]
end
