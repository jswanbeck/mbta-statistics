Rails.application.routes.draw do
  get '/home' => 'home#index'
  get '/transit/:type/:id' => 'transit#show'

  root 'home#index'
end
