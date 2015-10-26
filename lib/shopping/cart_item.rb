module Shopping
  class CartItem
    include Virtus.model

    attribute :variant, Catalog::Variant
    attribute :quantity, Integer

    def sub_total
      quantity * variant.amount
    end
  end
end
