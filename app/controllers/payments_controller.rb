class PaymentsController < ApplicationController
  def create_checkout_session
    session = Stripe::Checkout::Session.create({
      payment_method_types: ['card'],
      line_items: [{
        price_data: {
          currency: 'usd',
          product_data: {
            name: 'T-shirt',
          },
          unit_amount: 2000,
        },
        quantity: 1,
      }],
      mode: 'payment',
      success_url: 'http://localhost:3000/payment_success?session_id={CHECKOUT_SESSION_ID}',
      cancel_url: 'http://localhost:3000/payment_cancel',
    })

    render json: { id: session.id }
  end
end
