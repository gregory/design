module Checkout
  class PlaceOrder
    include Interactor

    organize Catalog::PickupItems, Finance::MakePayment

    service :create_shipment, default: Shipping::CreateShipment
    service :order_repository, default: Repositories::Order.new # pass those defaults below and overwrite them if overwrote below

    VALIDATOR = Vanguard::Validator.build do
      validates_presence_of :order
      validates_presence_of :token
    end

    before do
      @params = context.place_order
      validation = VALIDATOR.call(@params)
      context.fail(errors: validation.violations) unless validation.valid?

      @order = @params[:order]
      @order.subscribe(services.order_repository)
      @order.on(:order_paid) do
        services.create_shipment.call(create_shipment: { shipment: @order.shipment})
      end

      context.pickup_items = { cart: @order.cart.cart     }
      context.make_payment = { payment: @order.payment, token: @params[:token] }

      channels[:make_payment].on(:payment_successful) do |payment|
        @order.paid!
      end

      channels[:make_payment].on(:payment_rollback) do |payment|
        @order.failed!
      end
    end
  end
end
