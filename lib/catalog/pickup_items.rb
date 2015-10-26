module Catalog
  class PickupItems
    include Interactor

    service :lock_service, default: Wharehouse::LockService.new

    VALIDATOR = Vanguard::Validator.build do
      validates_presence_of :cart
    end

    before do
      @params = context.pickup_items

      validation = VALIDATOR.call(@params)
      context.fail(errors: validation.violations) unless validation.valid?

      @items = @params[:cart].items # Item = product + quantiy
      @lock_service = services.lock_service
    end

    def call
      # We only care about business events, the repo service will be responsible for infra
      # errors, like network failure etc. Business event would be item not held because
      # unavailable. This is also why we don't care about business events in rollback in
      # this scenario
      @lock_service.on(:items_locked) do
        emit(:pickup_items, :ok)
      end
      @lock_service.on(:items_unavailable) do |errors|
        with_fail do
          emit(:pickup_items, :ok, errors: errors)
        end
      end

      context.lock = @lock_service.lock(@items)
    end

    def rollback
      @lock_service.unlock(context.lock)
      #release product
    end

  end
end
