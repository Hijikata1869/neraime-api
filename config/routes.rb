Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'auth', to: 'auth#create'
      get 'current_user', to: 'auth#current_user'
      get 'stores/show_by_name', to: 'stores#show_by_name'
      resources :users, except: :index do
        get 'crowdedness_list', on: :member
      end
      resources :stores do
        get 'crowdedness_list', on: :member
      end
      resources :crowdednesses, except: [:index, :show, :update]
    end
  end
end
