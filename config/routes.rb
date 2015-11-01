Rails.application.routes.draw do
	root "encryptions#index"
	resources :encryptions
end
