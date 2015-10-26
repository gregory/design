module Finance
  class MakePayment
    include Interactor

    service :charge_service, default: PaymentService::Charge
    service :transactions_repository, default: REPOSITORIES[:transactions]

    channel :make_payment

    before do
      @payment = context.make_payment.fetch(:payment)

      @customer.cast_as(Roles::Buyer)
      @customer.subscribe(services.charge_service)
    end

    def call
      svc = services.charge_service.new(@payment)

      svc.on(:charge_successful) do |charge|
        transaction = Transaction.new_from_charge(charge)
        emit(:make_payment, :ok, transaction)
      end

      svc.on(:transaction_failed, :transaction_invalid) do |errors|
        with_fail(errors) { emit(:make_payment, :ko, errors) }
      end

      svc.run
    end

    after do
      @customer.uncast
    end
  end
end
