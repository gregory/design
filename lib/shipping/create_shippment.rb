module Shipping
  class CreateShippment
    include Interactor

    service :shipment_service, default: Shipping::ShipService.new

    before do
      @shipment = context.create_shipment.fetch(:shipment)
    end

    def call
    end
  end
end
