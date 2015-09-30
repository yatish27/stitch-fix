Rails.application.routes.draw do
  resources :items, only: [:index]
  resources :clearance_batches, only: [:index, :create, :update, :new, :show] do
    collection do
      post 'create_by_file'
    end

    member do
      post "add_item"
    end

  end
  root to: "clearance_batches#new"
end
