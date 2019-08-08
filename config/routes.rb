Rails.application.routes.draw do
  devise_for :users, path: 'web', :controllers => {
    :omniauth_callbacks => "users/omniauth_callbacks"
  }

  devise_scope :user do
    get '/', to: 'devise/sessions#new'
  end

  #Web
  get '/main', to: 'views#main'
  get '/web/groups/create', to: 'views#create_group'
  post '/web/groups/create', to: "views#create"
  get '/web/groups/:group_id', to: "views#get_group"
  post '/web/groups/:group_id/messages', to: "views#send_message"
  delete '/web/groups/:group_id', to: "views#destroy_group"
  get '/web/users/:user_id', to: "views#user_profile"
  post '/web/users', to: "views#add_photo"
  get '/web/groups', to: "views#get_groups"
  put '/web/groups/:group_id/privacy', to: "views#change_group_privacy"
  post '/web/groups/:group_id/invites', to: "views#send_invite"
  delete '/web/invites/:invite_id/accept', to: "views#accept_invite"
  delete '/web/groups/:group_id/users/:user_id', to: "views#kick_user"

  # mount_devise_token_auth_for 'User', at: 'auth', controllers: {
  #   sessions: "sessions"
  # }

  namespace :api, defaults: {format: 'json'} do
      mount_devise_token_auth_for 'User', at: 'auth', skip: [:omniauth_callbacks], controllers: {
        sessions: "sessions"
      }
  end

  
  post   '/groups', to: 'groups#create'
  put    '/groups/:group_id/privacy', to: "groups#change_group_privacy"
  get    '/groups', to: 'groups#other_groups'
  delete '/groups/:group_id', to: 'groups#delete_group'
  delete '/groups/:group_id/users/:user_id', to: 'groups#remove_user'
  get    '/groups/:group_id', to: 'groups#get_group'
  post   '/groups/:group_id/invites', to: 'groups#send_invite'
  delete '/groups/:group_id', to: 'groups#delete'
  get    '/users/:user_id', to: 'users#show'
  post   '/user/avatar', to: 'users#create_avatar'
  put    '/user/avatar', to: 'users#create_avatar'
  get    '/users/:user_id/avatar', to: 'users#show_avatar'
  get    '/user', to: 'users#get_user'
  get    '/users/:user_id/groups', to: 'groups#show'
  get    '/user/groups', to: 'groups#get_groups'
  post   '/users/:user_id/groups', to: 'users#group_join'
  delete '/users/:user_id/groups/:group_id', to: 'users#group_leave'
  post   '/groups/:group_id/messages', to: 'messages#create'
  get    '/groups/:group_id/messages', to: 'messages#show'

  get '*path' => redirect('/')

  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
