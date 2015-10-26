class Shippment
  include Virtus.model

  attribute :uuis, String
  attribute :method, String
  attribute :status, String
  attribute :order, Order
  attribute :shipping_address, Customer::Address
end
