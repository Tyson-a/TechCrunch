# app/controllers/checkout_controller.rb
class CheckoutController < ApplicationController
  before_action :set_cart, only: [:create_stripe_session]
  before_action :set_stripe_api_key

  # app/controllers/checkout_controller.rb
def create_stripe_session
  line_items = @cart.cart_items.map do |item|
    {
      price_data: {
        currency: 'usd',
        product_data: {
          name: item.product.name,
        },
        unit_amount: (item.product.price * 100).to_i,
      },
      quantity: item.quantity
    }
  end

  stripe_session = Stripe::Checkout::Session.create(
    payment_method_types: ['card'],
    line_items: line_items,
    mode: 'payment',
    success_url: stripe_auto_post_url,  # Redirects here after successful payment
    cancel_url: order_cancel_url
  )

  redirect_to stripe_session.url, allow_other_host: true
rescue Stripe::StripeError => e
  flash[:error] = e.message
  redirect_to carts_path
end


def cancel
  # Logic to handle when a user cancels their checkout at the Stripe payment page
  flash[:alert] = "Checkout was canceled. If this was an error, please try again or contact support."
  redirect_to cart_path  # Redirects user back to their cart
end



  private

  def set_stripe_api_key
    Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)
  end
end
