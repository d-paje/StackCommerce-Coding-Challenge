Rails.application.routes.draw do
  devise_for :users
  get 'search/screen_name', to: 'search#results'
  get 'search/search', to: 'search#search'
  root 'search#home'
end
