Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :product_images do
    collection { post :import }
    delete 'delete_multiple', on: :collection
  end
  root 'product_images#index'
  get '/all_products', to: 'product_images#all_products', as: 'all_products'
end
