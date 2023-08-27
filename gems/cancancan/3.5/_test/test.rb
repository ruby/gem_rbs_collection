# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "cancancan"
require "active_record"

class Post < ActiveRecord::Base
end

class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Post, public: true

    return unless user.present?  # additional permissions for logged in users (they can read their own posts)
    can :read, Post, user: user

    return unless user.admin?  # additional permissions for administrators
    can :read, Post
  end
end

class TestController < ActionController::Base
  def show
    @post = Post.find(1)
    authorize! :read, @post
  end
end
