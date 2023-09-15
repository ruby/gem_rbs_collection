# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "recaptcha"
require "action_controller"
require "active_record"

class User < ActiveRecord::Base
end

class UsersController < ActionController::Base
  def create
    @user = User.new(**params)
    if verify_recaptcha(model: @user) && @user.save
      redirect_to @user
    else
      render 'new'
    end
  end
end
