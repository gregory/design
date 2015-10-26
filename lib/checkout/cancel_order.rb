module Order
  class CancelOrder
    include Interactor

    CancelOnly = Assertion.guard :order do
      Order::IsLessThan24h[order] & Order::IsNotCheap[order]
    end

    before do
      can_cancel = CancelOnly[context.order]
      unless can_cancel.valid?
        context.fail(cancel_failed: can_cancel.messages)
      end
    end
  end
end
