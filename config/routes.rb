Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    sessions: "sessions"
  }

  post '/groups', to: 'groups#create'
  get  '/users/:user_id/groups', to: 'groups#show'
  post '/groups/:group_id/messages', to: 'messages#create'
  get  '/groups/:group_id/messages', to: 'messages#show'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
