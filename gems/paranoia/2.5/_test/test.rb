# It is type checked by `steep check` command.

require "paranoia"

class Product < ActiveRecord::Base
  acts_as_paranoid delete_all_enabled: true

  scope :promoted, -> { where(promoted: true) }
  scope :regular, -> { where(promoted: false) }

  after_destroy :update_document_in_search_engine
  after_restore :update_document_in_search_engine, if: :requires_search_engine_update?
  after_real_destroy :remove_document_from_search_engine, if: ->(product) { product.deleted? }

  def update_document_in_search_engine
    # ...
  end

  def remove_document_from_search_engine
    # ...
  end

  def requires_search_engine_update?
    true
  end
end

product = Product.new
product.paranoid?
product.paranoia_destroy

product = Product.new
product.paranoia_delete
product.restore

product = Product.new
product.delete
product.restore!

product = Product.new
product.destroy
product.paranoia_destroyed?
product.deleted?
product.really_destroy!

Product.with_deleted.regular
Product.only_deleted.promoted
Product.deleted.where(id: 47)
Product.restore(47)
Product.restore([47, 99])
Product.paranoid?
