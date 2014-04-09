Mons2015Mozaic::Application.routes.draw do
  # OmniAuth (facebook)
  match '/auth/:provider/callback', :to => 'sessions#create',  :via => [:get, :post]
  match '/auth/failure',            :to => redirect('/'),      :via => [:get, :post]
  get   '/signout',                 :to => 'sessions#destroy', :as => :signout

  post '/users',                    :to => 'users#update',     :via => [:post]

  root 'application#index'
end
