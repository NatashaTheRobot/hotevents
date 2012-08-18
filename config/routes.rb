Hotevents::Application.routes.draw do
  root to: "events#index"
  resource :events
  get '/auth/facebook/callback', to: 'sessions#create'
  get '/signout' => 'sessions#destroy', as: :signout
end
