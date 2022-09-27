# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "sorcery"

class User
  extend Sorcery::Model
  authenticates_with_sorcery!
end

User.authenticate('hoge@example.com', 'password')
User.authenticate('fuga@example.com', 'password') do |user, failure_reason|
  p user
  p failure_reason
end

class TestController
  include Sorcery::Controller
end

controller = TestController.new
controller.require_login
controller.login('hoge@example.com', 'password')
controller.login('hoge@example.com', 'password') { |user| user }
controller.login('hoge@example.com', 'password') do |user, failure_reason|
  p user
  p failure_reason
end
controller.current_user
controller.logout

user = User.new
controller.auto_login(user)

controller.redirect_back_or_to('/')
controller.redirect_back_or_to('/', { notice: 'success' })
