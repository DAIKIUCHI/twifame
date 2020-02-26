Rails.application.routes.draw do

  devise_for :users, :controllers => {
    :omniauth_callbacks => 'users/omniauth_callbacks',
    :sessions => 'users/sessions',
    :registrations => 'users/registrations'
   }

  # ログアウト
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  # root 'static_pages#home'
  root 'tweets#new'
  get 'static_pages/home'
  get 'static_pages/faq'
  get 'static_pages/about'
  get 'static_pages/delete'
  resources :users, only: [:show]
  resources :tweets
end
