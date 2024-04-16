# app/controllers/checkout_controller.rb
class CheckoutController < ApplicationController
  # This action will render the checkout page
  def show
    # Add any setup code here for preparing the checkout page
    # For example, you might load user info or cart details
  end

  # This action creates a Stripe Checkout session
  def create_session
    @session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [{
        name: "Product Name",
        description: "Product Description",
        amount: 2000, # Amount in cents, adjust as needed
        currency: 'usd',
        quantity: 1,
      }],
      success_url: checkout_success_url + '?session_id={CHECKOUT_SESSION_ID}',
      cancel_url: checkout_cancel_url,
    )

    respond_to do |format|
      format.json { render json: { id: @session.id } }
    end
  end

  # Optionally, you can include actions to handle success and cancellation routes
  def success
    # Here you would handle post-payment success, such as updating order status
    # Optionally, you can retrieve the session ID if needed to confirm details
    @session_id = params[:session_id]
  end

  def cancel
    # Handle the case where a user cancels the payment
  end
end
