class PaypalController < ApplicationController
  def checkout
    if (@payment = new_paypal_service).error.nil?
      @transaction.update(payment_token: @payment.token)
      @redirect_url = @payment.links.find { |v| v.method == 'REDIRECT' }.href
    else
      @message = @payment.error
    end
  end

  def success 
    @transaction = Transaction.find_by(token)
    @payment = execute_recurring_payment(token)
    if @payment.success?
      @transaction.update(payment_token: @payment.id)
      @transaction.success!
    else
      @transaction.fail!
    end
  end
  
  private

  def new_paypal_service
    PaypalService.new({
      transaction: @recurring_transaction,
      return_url: 'http://localhost:3000/new-paypal-subscription',
      cancel_url: 'http://localhost:3000/error-paypal-subscription'
    }).create_recurring_agreement
  end

  def execute_recurring_payment(agreement_token)
    PaypalService.execute_agreement(agreement_token)
  end
end