require "active_support/all"
require "validate_url"

class Unicorn
  include ActiveModel::Validations

  # @dynamic homepage, homepage=, ftpsite, ftpsite=, mirrors, mirrors=
  attr_accessor :homepage, :ftpsite, :mirrors

  def persisted?
    false
  end

  validates :homepage, url: true
  validates :homepage, url: { allow_nil: true }
  validates :homepage, url: { allow_blank: true, no_local: true, schemes: %w[https http] }
  validates :homepage, url: { public_suffix: true, message: "is not a URL" }
  validates :homepage, url: { message: :invalid_url }
  validates :homepage, url: { message: ->(_object, _data) { "is not a URL" } }
  validates :mirrors, url: { accept_array: true, schemes: [:https] }
  validates_url :homepage, allow_blank: true
  validates_url :ftpsite, schemes: ["ftp"], message: :url
  validates_url :ftpsite, message: proc { |_object, _data| "is not an FTP URL" }
  validates_url :homepage, :mirrors, no_local: true, public_suffix: false, accept_array: true, if: :persisted?, on: :create
end

unicorn = Unicorn.new
unicorn.homepage = "https://example.com"
unicorn.valid?

ActiveModel::Validations::UrlValidator.is_a?(Class)
