require "pundit"
require "action_controller"

class Post
end

class PostPolicy
  def initialize(user, record)
    @user = user
    @record = record
  end

  def update?
    true
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      @scope
    end
  end
end

class ApplicationController < ActionController::Base
  include Pundit::Authorization

  def show
    post = Post.new
    authorize(post)
    authorize(post, :update?)
    policy(post)
    policy_scope(Post)

    raise Pundit::NotAuthorizedError
    raise Pundit::NotDefinedError
  end
end
