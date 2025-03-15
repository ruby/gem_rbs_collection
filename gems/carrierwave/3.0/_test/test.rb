# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "carrierwave"

class AvatarUploader < CarrierWave::Uploader::Base
  storage :file
end

class MyUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  process resize_to_fit: [800, 800]

  version :thumb do
    process resize_to_fill: [200,200]
  end
end

class ApplicationRecord < ActiveRecord::Base
end

class User < ApplicationRecord
  # @dynamic avatar
  mount_uploader :avatar, AvatarUploader
end

avatar = User.new.avatar
avatar.path
avatar.blank?
avatar.url
avatar.store_path
avatar.cached?
