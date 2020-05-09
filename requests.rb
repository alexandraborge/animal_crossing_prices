require 'twilio-ruby'
require 'sinatra'
require_relative 'my_recipes'
require_relative 'items'
require 'byebug'

class Responses

  def initialize(request)
    @request = request
  end

  def build_response
    request = @request.downcase
    number = request.split.detect  {|x| x[/\d+/]}.to_i || 10
    category = request.split.detect { |x| Items.categories.include?(x) } || ''
    case request
    when "top #{number} overall"
      Items.most_expensive_overall(number)
    when "top #{number} #{category}"
      Items.most_expensive_by_category(category, number)
    else
      "Don't know that request"
    end
  end
end


post '/' do
  twiml = Twilio::TwiML::MessagingResponse.new do |r|
    r.message(
      body: Responses.new(params["Body"]).build_response
      )
  end

  twiml.to_s  
end
