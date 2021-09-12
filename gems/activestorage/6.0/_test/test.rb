class User < ActiveRecord::Base
  has_one_attached :one_image
  has_many_attached :many_image
end

user = User.new
one = ActiveStorage::Attached::One.new("one_image", user)
one.url
