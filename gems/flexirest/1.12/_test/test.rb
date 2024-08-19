require "flexirest"

class Person < Flexirest::Base
  base_url "https://www.example.com/api/v1"

  get :all, "/people"
  get :find, "/people/:id"
  put :save, "/people/:id"
  post :create, "/people"
  delete :remove, "/people/:id"
end
