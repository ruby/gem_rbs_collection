require "active_record"
require "active_type"

class SignIn < ActiveType::Object
  attribute :username, :string
  attribute :password, :string

  validates :username, presence: true
  validates :password, presence: true

  before_save :before_save_callback
  after_save :after_save_callback

  private

  def before_save_callback
  end

  def after_save_callback
  end
end

SignIn.create(username: 'username', password: 'password')
SignIn.create!(username: 'username', password: 'password')

sign_in = SignIn.new(username: 'username', password: 'password')
sign_in.valid?
sign_in.errors
sign_in.save
sign_in.save!

class Credential < ActiveRecord::Base
end

class User < ActiveRecord::Base
  # @dynamic credentials
  has_many :credentials
end

class SignUpCredential < ActiveType::Record[Credential]
end

class SignUp < ActiveType::Record[User]
  attribute :foo, :string

  change_association :credentials, class_name: 'SignUpCredential'

  def sign_up_func
  end
end

SignUp.create(username: 'username', password: 'password', foo: 'foo')
SignUp.create!(username: 'username', password: 'password', foo: 'foo')

sign_up = SignUp.new
sign_up.valid?
sign_up.errors
sign_up.credentials
sign_up.save
sign_up.save!
sign_up.sign_up_func

user = User.find(1)
ActiveType.cast(user, SignUp).sign_up_func
ActiveType.cast(user, SignUp, force: true).sign_up_func

SignUp.model_name
