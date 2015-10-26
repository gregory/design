module Catalog
  class Product
    include Virtus.model

    attribute :name, String
    attribute :description, String
    attribute :brand, String
    attribute :variants, Array[Variant]
  end
end
