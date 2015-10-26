module Finance
  class Payment
    include Virtus.model

    attribute :uuid, String
    attribute :amount, Integer
    attribute :masked_card, String
    attribute :billing_address, Customer::Address
    attribute :paid_at, DateTime
  end
end
