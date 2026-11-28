# frozen_string_literal: true

require "mime/types/data"

# @type var version: String
version = MIME::Types::Data::VERSION
version.split(".")

# @type var path: String
path = MIME::Types::Data::PATH
File.join(path, "content_type_mime.db")
