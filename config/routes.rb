Rails.application.routes.draw do
  resources :asset_classes, except: [:new, :edit]
end
