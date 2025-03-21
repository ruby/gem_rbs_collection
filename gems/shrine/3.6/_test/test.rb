require "shrine"
require "shrine/storage/file_system"

Shrine.storages = {
  cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"), # temporary
  store: Shrine::Storage::FileSystem.new("public", prefix: "uploads"),       # permanent
}

Shrine.plugin :activerecord           # loads Active Record integration
Shrine.plugin :cached_attachment_data # enables retaining cached file across form redisplays
Shrine.plugin :restore_cached_data    # extracts metadata for assigned cached files

class ImageUploader < Shrine
  # plugins and uploading logic
end

class Photo < ActiveRecord::Base
  include ImageUploader::Attachment(:image) # adds an `image` virtual attribute
end

attacher = Shrine::Attacher.new
attacher.assign('{"id":"asdf.jpg","storage":"cache","metadata":{...}}')
attacher.file
