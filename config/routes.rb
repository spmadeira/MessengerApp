Rails.application.routes.draw do
  devise_for :users, path: 'web'

  devise_scope :user do
    get '/', to: 'devise/sessions#new'
  end

  #Web
  get '/main', to: 'views#main'
  get '/web/groups', to: 'views#create_group'
  post '/web/groups/create', to: "views#create"
  get '/web/groups/:group_id', to: "views#get_group"

  # mount_devise_token_auth_for 'User', at: 'auth', controllers: {
  #   sessions: "sessions"
  # }


  post   '/groups', to: 'groups#create'
  delete '/groups/:group_id', to: 'groups#delete'
  get    '/users/:user_id', to: 'users#show'
  post   '/users/:user_id/avatar', to: 'users#create_avatar'
  put    '/users/:user_id/avatar', to: 'users#create_avatar'
  get    '/users/:user_id/avatar', to: 'users#show_avatar'
  get    '/users/:user_id/groups', to: 'groups#show'
  post   '/users/:user_id/groups', to: 'users#group_join'
  delete '/users/:user_id/groups/:group_id', to: 'users#group_leave'
  post   '/groups/:group_id/messages', to: 'messages#create'
  get    '/groups/:group_id/messages', to: 'messages#show'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
