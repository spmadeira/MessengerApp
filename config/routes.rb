Rails.application.routes.draw do
  #devise_for :users

  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    sessions: "sessions"
  }

  post   '/groups', to: 'groups#create'
  delete '/groups/:group_id', to: 'groups#delete'
  post   '/users/:user_id/avatar', to: 'users#create_avatar'
  put    '/users/:user_id/avatar', to: 'users#create_avatar'
  get    '/users/:user_id/avatar', to: 'users#show_avatar'
  get    '/users/:user_id/groups', to: 'groups#show'
  post   '/groups/:group_id/messages', to: 'messages#create'
  get    '/groups/:group_id/messages', to: 'messages#show'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
