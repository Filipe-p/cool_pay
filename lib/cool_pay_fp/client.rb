module Coolpay

  class Client
    attr_accessor :api_url, :user_name, :api_key, :token

    def initialize(api_url:, user_name:, api_key:)
      @api_url = api_url
      @user_name = user_name
      @api_key = api_key
      login
    end


    def create_recipient(name:)
      request = 'post'
      body = {"recipient": {"name": name}}
      url_extension = 'recipients'

      response = call_api request: request, body: body, url_extension: url_extension

    end

    def search_recipients(name:nil)
      request = 'get'
      url_extension = 'recipients'

      if name.nil?
        response = call_api request: request, url_extension: url_extension
      else
        query = url_extension + '?name=' + name.gsub(' ', '%20')
        response = response = call_api request: request, url_extension: query
      end

      response.code == 200 ? JSON.parse(response.body)["recipients"] : "Something is up! Check this response code: #{response.code}"
    end

    def make_payment(amount:, recipient_id:, currency:'GBP' )
      body = {
                "payment": {
                  "amount": amount,
                  "currency": currency,
                  "recipient_id": recipient_id
                }
              }
      request = 'post'
      url_extension = 'payments'

      response = call_api request: request, url_extension: url_extension, body: body
      response.code == 201 ? response : "Something is up! Check this response code: #{response.code}"
      #Error handle
      # create a new recipient object?

    end

    def list_payments
      url_extension = 'payments'
      request = 'get'
      response = call_api request: request, url_extension: url_extension)
      response.code == 200 ? response : "Something is up! Check this response code: #{response.code}"
    end

    private

    def call_api(request:, url_extension:, body:nil)
      headers = {'Content-Type' => 'application/json',
                 'Authorization' => "Bearer #{@token}"}

      body.nil? ? '' : json_body = JSON.generate(body)

      case request
      when 'post'
        HTTParty.post 'https://coolpay.herokuapp.com/api/' + url_extension, body: json_body, headers: headers
      when 'get'
        HTTParty.get 'https://coolpay.herokuapp.com/api/' + url_extension , headers: headers
      end
    end

    def login
      headers = {'Content-Type' => 'application/json'}
      body = {username: @user_name, apikey: @api_key}
      json_body = JSON.generate(body)

      response = HTTParty.post 'https://coolpay.herokuapp.com/api/login', body: json_body, headers: headers

      @token = JSON.parse(response.body)["token"]
      # Error handle?
    end
  end
end
