Spree::CheckoutController.class_eval do
  before_filter :redirect_to_payone, :only => [:update]

  def redirect_to_payone
    return unless (params[:state] == "payment")
    return unless params[:order][:payments_attributes]

    payment_method = Spree::PaymentMethod.find(params[:order][:payments_attributes].first[:payment_method_id])
    if payment_method.kind_of?(Spree::PaymentMethod::PayoneFrontend)
      @order.update_from_params(params, permitted_checkout_attributes)
      @order.payone_hash = payment_method.build_payone_exit_param(@order)
      @order.save!
      redirect_to payment_method.build_url(@order)
    end
  end

end
