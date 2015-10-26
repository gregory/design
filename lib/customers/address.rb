module Customers
  class Address
    include Virtus.value_object

    values do
      attribute :firstname, String
      attribute :lastname, String
      attribute :street, String
      attribute :zipcode, String
      attribute :city, String
    end
  end
end
