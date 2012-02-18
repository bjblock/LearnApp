LearnApp::Application.routes.draw do
  
  root :to => 'pages#index'
  
  get "uploads/index"

  get "pages/index"
  
  post "pages/quiz"
  
  get "decks/shownext/:id" => 'decks#shownext'
  get "decks/show/:id" => 'decks#show'
  
  get "decks/check/:qid/:aid" => "decks#check"

  resources :decks

  resources :choices

  resources :answers

  resources :questions

end
