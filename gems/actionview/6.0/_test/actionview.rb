class Test
  class ApplicationController < ActionController::Base
  end

  class UsersController < ApplicationController
    def create
      render :new, status: :unprocessable_entity
    end

    def update
      render "edit", status: :unprocessable_entity
    end
  end
end
