Rails.application.routes.draw do
  # Routes for Post Controller
  resources :post
  get '/post/:id/like' , to: 'post#like'
  get '/post/:id/dislike' , to: 'post#dislike'
  get '/post/:id/archive' , to: 'post#archive'
  get 'post/:id/delete' , to: 'post#destroy'

  # Routes for Session Controller
  get '/login' , to: 'session#loginView'
  post '/login' , to: 'session#login'
  get '/logout' , to: 'session#logout'
  get '/kk' , to: 'session#loginView'

  # Routes for User Controller
  get '/home' , to: 'user#home'
  get '/signup' , to: 'user#new'
  post '/signup' , to: 'user#create'
  get '/user/:username' , to: 'user#show'
  get '/profile' , to: 'user#edit'
  put '/profile' , to: 'user#update'
  delete '/me' , to: 'user#destroy'
  get '/follow/:id' , to: 'user#follow'
  get '/unfollow/:id' , to: 'user#unfollow'
  get '/follow/accept/:reqid' , to: 'user#accept_follow'
  get '/follow/reject/:reqid' , to: 'user#reject_follow'

  # Routes for Search Controller
  get '/search' , to: 'search#search'


  # mount Test::API => "/"
  mount Api => "/api"
    
end
