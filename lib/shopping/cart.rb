module Shopping
  class Cart
    include Virtus.model

    attribute :uuid, String
    attribute :items, Array[CartItem]
    attribute :coupons, Array[Marketing::Coupons]
    attribute :discounts, Array[Marketing::Discount]

    def sub_total
      items.map(&:sub_total).sum
    end
  end
end
