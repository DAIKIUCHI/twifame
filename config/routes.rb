Rails.application.routes.draw do

  devise_for :users, :controllers => {
    :omniauth_callbacks => 'users/omniauth_callbacks',
    :sessions => 'users/sessions'
   }

  # ログアウト
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  root 'static_pages#home'
  get 'static_pages/home'
  get 'static_pages/faq'
  get 'static_pages/about'
  resources :users, only: [:show]

  resources :tweets do
    collection do
      get 'reply'
      get 'test'
      get 'form'
    end
  end
end
