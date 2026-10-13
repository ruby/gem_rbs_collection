class User < ActiveRecord::Base
  has_one_attached :one_image
  has_many_attached :many_image
  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
  end
  has_many_attached :photos do |attachable|
    attachable.named_variants
  end
end

user = User.new
one = ActiveStorage::Attached::One.new("one_image", user)
one.url
ActiveStorage::Blob.new.signed_id(purpose: :download).size
