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
      body = {"recipient": {"name": name}}
      response = call_api  url_extension: '/recipients', request: 'post', body: body
      response.code == 201 ? JSON.parse(response.body)['recipient'] : "Something is up! Check this response code: #{response.code}"
    end

    def search_recipients(name:nil)
      if name.nil?
        response = call_api url_extension: '/recipients', request: 'get'
      else
        query = '/recipients?name=' + name.gsub(' ', '%20')
        response = response = call_api url_extension: query, request: 'get'
      end

      response.code == 200 ? JSON.parse(response.body)['recipients'] : "Something is up! Check this response code: #{response.code}"
    end

    def make_payment(amount:, recipient_id:, currency:'GBP' )
      body = {
                "payment": {
                  "amount": amount,
                  "currency": currency,
                  "recipient_id": recipient_id
                }
              }

      response = call_api url_extension: '/payments', request: 'post', body: body
      response.code == 201 ? JSON.parse(response.body)['payment'] : "Something is up! Check this response code: #{response.code}"
    end

    def list_payments
      response = call_api url_extension: '/payments', request: 'get'
      response.code == 200 ? JSON.parse(response.body)['payments'] : "Something is up! Check this response code: #{response.code}"
    end

    private
    def call_api(request:, url_extension:, body:nil)
      headers = {'Content-Type' => 'application/json',
                 'Authorization' => "Bearer #{@token}"}

      body.nil? ? '' : json_body = JSON.generate(body)

      case request
      when 'post'
        HTTParty.post 'https://coolpay.herokuapp.com/api' + url_extension, body: json_body, headers: headers
      when 'get'
        HTTParty.get 'https://coolpay.herokuapp.com/api' + url_extension , headers: headers
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
