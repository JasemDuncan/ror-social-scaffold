Rails.application.routes.draw do

  root 'posts#index'

  devise_for :users

  get 'requests', to: 'users#requests'

  resources :friendships

  resources :users, only: [:index, :show]do
    resources :friendships
  end  

  resources :posts, only: [:index, :create] do
    resources :comments
    resources :likes, only: [:create, :destroy]
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
