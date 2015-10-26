module Orders
  class Order
    include Virtus.model

    attribute :uuid, String
    attribute :customer, Customer
    attribute :cart, Cart
    attribute :shippment, Shippment
    attribute :payment, Financial::Payment

    attribute :placed_at, DateTime
    attribute :canceled_at, DateTime
    attribute :status, String

    IsLessThan24h = Assertion.about :created_at do
      created_at < 24.hours.ago
    end

    IsNotCheap = Assertion.about :payment do
      payment.amount > 200
    end

    def sub_total
      cart.sub_total
    end

    def paid!
      self.status = :paid # todo: state machine
      publish(:order_paid, order: self)
    end
  end
end
