require "devise"
require "active_record"

class CustomConfirmationsController < Devise::ConfirmationsController
end

class CustomOmniauthCallbacksController < Devise::OmniauthCallbacksController
end

class CustomPasswordsController < Devise::PasswordsController
end

class CustomRegistrationsController < Devise::RegistrationsController
end

class CustomSessionsController < Devise::SessionsController
end

class CustomUnlocksController < Devise::UnlocksController
end

class User < ActiveRecord::Base
  devise :database_authenticatable, :omniauthable, :confirmable,
         :recoverable, :registerable, :rememberable,
         :trackable, :timeoutable, :validatable, :lockable,
         authentication_keys: [:email]
end
