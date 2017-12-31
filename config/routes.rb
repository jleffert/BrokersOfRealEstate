Rails.application.routes.draw do
  resources :lots
  get 'contact_us' => 'site#contact_us'
  post 'contact_form' => 'site#send_contact_form'
  root 'site#index'
end
