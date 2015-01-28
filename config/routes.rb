Rails.application.routes.draw do
  resources :allocations, except: [:new, :edit]
  resources :asset_classes, except: [:new, :edit]
  resources :funds, except: [:new, :edit]
  resources :lots, except: [:new, :edit]
  resources :portfolios, except: [:new, :edit]
end
