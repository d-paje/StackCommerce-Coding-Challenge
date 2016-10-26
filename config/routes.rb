Rails.application.routes.draw do
  devise_for :users
  get 'search/screen_name', to: 'search#results'
  root 'search#home'
end
