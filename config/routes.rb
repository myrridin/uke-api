Rails.application.routes.draw do
  resources :songs, only: [:show, :create] do
    collection do
      post :cleanup_text
    end
  end
end
