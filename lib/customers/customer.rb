module Customers
  class Customer
    include Virtus.model
    include Casting::Client

    attribute :uuid, String
    attribute :name, String
    attribute :age, Integer
  end
end
