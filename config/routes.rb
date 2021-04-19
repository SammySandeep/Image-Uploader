Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :product_images do
    collection { post :import }
    delete 'delete_multiple', on: :collection
  end
  root to: 'home#index'
  get 'help', to: 'home#help'
  # root 'product_images#index'
  get '/all_products', to: 'product_images#all_products', as: 'all_products'
  get 'import_csv', to: 'product_images#import_csv', as: 'import_csv'
  post '/shopify/delete_product', to: 'shopify#delete_product'
  post '/shopify/update_product', to: 'shopify#update_product'
end
