Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  post 'login', to: 'users#login'
  post 'sign_up', to: 'users#sign_up'
  resources 'conversations', only: [:index, :show] do
    get 'messages', to: 'conversations#show_chats'
  end
  post 'messages', to: 'chats#create'
end
