Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, except: :index do
        get 'crowdedness_list', on: :member
      end
      resources :stores do
        get 'crowdedness_list', on: :member
      end
      resources :crowdednesses, except: [:index, :show, :update]
      post 'auth', to: 'auth#create'
    end
  end
end
