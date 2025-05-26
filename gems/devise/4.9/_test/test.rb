require "devise"
require "active_record"

class CustomSessionsController < Devise::SessionsController
end

class User < ActiveRecord::Base
  devise :database_authenticatable, :omniauthable, :confirmable,
         :recoverable, :registerable, :rememberable,
         :trackable, :timeoutable, :validatable, :lockable,
         authentication_keys: [:email]
end
