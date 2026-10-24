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
    policy_scope(Post, policy_scope_class: PostPolicy::Scope)
    pundit_user
    pundit.policy!(post)
    pundit_policy_authorized?
    pundit_policy_scoped?
    permitted_attributes(post, :update)
    pundit_params_for(post)
    pundit_reset!

    Pundit.authorize(nil, post, :update?)
    Pundit.policy_scope!(nil, Post)
    Pundit::PolicyFinder.new(post).param_key
    Pundit::Context.new(user: nil).authorize(post, query: :update?, policy_class: PostPolicy)

    error = Pundit::NotAuthorizedError.new(query: :update?, record: post, policy: PostPolicy.new(nil, post))
    error.query
    error.record
    Pundit::NotAuthorizedError.new("denied")

    raise Pundit::NotAuthorizedError
    raise Pundit::NotDefinedError
    raise Pundit::AuthorizationNotPerformedError
  end
end
