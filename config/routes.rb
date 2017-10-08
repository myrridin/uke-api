Rails.application.routes.draw do
  resources :songs, only: [:show, :create]
end
