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

blob = ActiveStorage::Blob.new
blob.content_type&.start_with?("image/")
blob.byte_size + 1
blob.checksum&.size
blob.metadata["width"]
blob.service_name.to_sym
blob.created_at.to_date
attachment = ActiveStorage::Attachment.new
attachment.name.to_sym
attachment.blob.byte_size
attachment.created_at.to_date

blob.key.size
blob.filename.extension.upcase
blob.filename.base.upcase
blob.filename.to_s.upcase
blob.url(expires_in: 5.minutes).size
blob.service_url_for_direct_upload.size
blob.service_headers_for_direct_upload.each_value(&:size)
blob.image? || blob.video?
