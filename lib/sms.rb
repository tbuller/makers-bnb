require 'twilio-ruby'
require 'dotenv'
require_relative 'user'
Dotenv.load('twilio.env')

class SMS

  def initialize(user)
    # Requires customer name and mobile to initialize, Twillio SID and AUTH token saved in ENV"
    @user = user
    @client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_ACCOUNT_AUTH_TOKEN'])
  end

  def send_sms
    # Sends SMS using Twilio API, addressed to customer and with estimated delivery time
    @client.messages.create(
    from: ENV['TWILIO_TEST_MOBILE_NUMBER'], # Twilio mobile number, in ENV
    to: ENV['MY_NUM'], # Customer mobile number
    body: "Hey #{@user}, your request to book was confirmed"
    )
    return "Text sent successfully."
  end


end