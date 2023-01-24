# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, path: ""
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"

  get "log_out", to: "home#log_out"

  authenticated :user do
    resources :users
    get "/blog/new" => "blog#new"
    post "/blog" => "blog#create"
    post "/blog/:id/like" => "blog#like_post"
  end

  get "blog/:id" => "blog#show"

  get "tags_demo" => "blog#tags_demo"

  authenticate :user, ->(u) { u.is_admin } do
    mount RailsAdmin::Engine => "/admin", as: "rails_admin"
  end
end
