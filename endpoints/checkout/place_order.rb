module Checkout
  module Endpoints
    class PlaceOrder < Grape::API
      format :json

      params do
        requires :user_uuid, type: String
        requires :cart_uuid, type: String
      end

      post 'orders' do
        customer = REPOSITORIES[:user].find_by_uuid(params[:user_uuid]).to_customer
        order = Order.new(customer: customer, items: items)
        placed_order = Order::PlaceOrder.call(place_order: { order: order})
        if placed_order.success?
        else
        end
      end
    end
  end
end
