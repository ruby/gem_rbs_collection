# It is type checked by `steep check` command.

require "paranoia"

class Product < ActiveRecord::Base
  acts_as_paranoid

  after_destroy      :update_document_in_search_engine
  after_restore      :update_document_in_search_engine
  after_real_destroy :remove_document_from_search_engine

  def update_document_in_search_engine
    # ...
  end

  def remove_document_from_search_engine
    # ...
  end
end

product = Product.new

product.destroy
puts product.deleted_at

product.really_destroy!

Product.with_deleted.where(id: 47)
