Rails.application.routes.draw do
  # Routes for Post Controller
  resources :post
  get '/post/:id/like' , to: 'post#like'
  get '/post/:id/dislike' , to: 'post#dislike'

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
  get '/pofile' , to: 'user#edit'
  put '/profile' , to: 'user#update'
  delete '/me' , to: 'user#destroy'
  get '/follow/:username' , to: 'user#follow'

  
  

end
