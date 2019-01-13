Rails.application.routes.draw do
  
  
    scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ , defaults: {format: :json} do
      
        resources :sessions, only: [:create]
        match 'sessions/logout'              => 'sessions#destroy',       via: :delete
        match 'sessions/check'               => 'sessions#check',         via: :get
        match 'users/asd'               => 'users#asd',         via: :get
        
        resources :users do
            member do
                put :deactivate
                put :activate
            end
        end
        match 'users/create_person' => 'users#create_person', via: :post
        
        resources :countries, only: [:index, :show, :create, :update, :destroy]
        resources :blogs
        resources :document_types
        resources :bank_accounts
        
    end
  
end
