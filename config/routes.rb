Rails.application.routes.draw do
  get 'words/show'
  get 'verses/index'
  get 'verses/show'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Route 1: GET all verses (index without nested data)
  get '/verses', to: 'verses#index'

  # Route 2: GET one verse (show verse with nested word data)
  get '/verses/:id', to: 'verses#show'

  # Route 3: GET one word (show word with nested matches)
  get '/words/:id', to: 'words#show'

  # Route 4: GET a verse by chapter and verse number
  get '/verses/:chapter/:verse', to: 'verses#show'

end
