Hotevents::Application.routes.draw do
  root to: "sessions#new"
  resource :sessions
  get '/auth/facebook/callback', to: 'sessions#create'
  get '/signout' => 'sessions#destroy', as: :signout
end
