Rails.application.routes.draw do
  post '/signup', to: 'users#create'
  get '/users/:user', to: 'users#show'
  patch '/users/:user', to: 'users#update'
  post '/close', to:'users#destroy'
end
