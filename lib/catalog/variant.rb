module Catalog
  class Variant
    include Virtus.model

    attribute :sku, String
    attribute :price, Integer
    attribute :cost, Integer
  end
end
