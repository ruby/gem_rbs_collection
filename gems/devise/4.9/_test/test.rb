require "devise"
require "active_record"
require "action_controller"

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

class ApplicationController < ActionController::Base
  devise_group :blogger, contains: [:user, :admin]

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, except: [:password])
    devise_parameter_sanitizer.permit(:sign_in) do |user_params|
      user_params.permit(:email, :password)
    end
    devise_parameter_sanitizer.sanitize(:sign_up)
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || super
  end

  def after_sign_out_path_for(resource_or_scope)
    return signed_in_root_path(resource_or_scope) if signed_in?(:admin)

    super
  end

  def create
    user = User.new
    allow_params_authentication!
    store_location_for(:user, "/dashboard")
    sign_in(user)
    sign_in(:user, user)
    sign_in(user, event: :authentication)
    bypass_sign_in(user, scope: :user)
    signed_in?
    signed_in?(:user)
    sign_in_and_redirect(user)
  end

  def destroy
    sign_out(:user)
    sign_out
    sign_out_all_scopes
    sign_out_and_redirect(:user)
  end

  def format_info
    devise_controller?
    is_navigational_format?
    is_flashing_format?
    request_format
  end
end

class ApiController < ActionController::API
  def create
    sign_in(User.new, store: false)
  end
end
