Rails.application.routes.draw do
  
    scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ , defaults: {format: :json} do
      
        resources :sessions, only: [:create]
        match 'sessions/logout'              => 'sessions#destroy',       via: :delete
        match 'sessions/check'               => 'sessions#check',         via: :get
        
        resources :users do
            member do
                put :deactivate
                put :activate
            end
        end
        match 'users/create_person' => 'users#create_person', via: :post
        match 'users/person/balance' => 'users#balance', via: :get
        match 'users/forgot_password'   => 'users#forgot_password',   via: :post
        match 'users/restore_password'  => 'users#restore_password',  via: :post
        match 'users/check_reset_password_token'  => 'users#check_reset_password_token',  via: :post
        match 'users/change_password'  => 'users#change_password',  via: :post
        
        resources :countries, only: [:index, :show, :create, :update, :destroy]
        resources :blogs
        resources :document_types
        resources :bank_accounts
        resources :charges do
            member do
                put :approve
                put :deny
            end
        end
        
        resources :calculators, only: [:create]
        resources :sales do
            member do
                put :approve
                put :deny
            end
        end
        resources :purchases do
            member do
                put :approve
                put :deny
            end
        end
        resources :settings, only: [:index, :create]
        resources :btc_charges do
            member do
                put :approve
                put :deny
                put :check
                put :successful
            end
        end
        resources :purchases
        resources :charge_points
        
    end
end
