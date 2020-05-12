Rails.application.routes.draw do
  resource :waves, only: [:create]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
