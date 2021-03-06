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
      response = call_api  url_extension: '/recipients', request: 'post', body: {"recipient": {"name": name}}
      if response.code == 201
        recipient_info = JSON.parse(response.body)['recipient']
        Recipient.new(name: recipient_info['name'], id: recipient_info['id'])
      else
        puts "Something is up! Check this response code: #{response.code}"
      end
    end

    def search_recipients(name:nil)
      if name.nil?
        response = call_api url_extension: '/recipients', request: 'get'
      else
        query = '/recipients?name=' + name.gsub(' ', '%20')
        response = response = call_api url_extension: query, request: 'get'
      end

      if response.code == 200
        recipients_array = JSON.parse(response.body)['recipients']
        recipients_array.map do |recipient_info|
          Recipient.new(name: recipient_info['name'], id: recipient_info['id'])
        end
        else
          puts "Something is up! Check this response code: #{response.code}"
        end
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
      if response.code == 201
        payment_info = JSON.parse(response.body)['payment']
        Payment.new(
          amount: payment_info['amount'],
          currency: payment_info['currency'],
          recipient_id: payment_info['recipient_id'],
          status: payment_info['status'],
          id: payment_info['id'])
      else
        puts "Something is up! Check this response code: #{response.code}"
      end

    end

    def list_payments
      response = call_api url_extension: '/payments', request: 'get'
      if response.code == 200
       payments = JSON.parse(response.body)['payments']
       payments.map do |payment_info|
          Payment.new(
          amount: payment_info['amount'],
          currency: payment_info['currency'],
          recipient_id: payment_info['recipient_id'],
          status: payment_info['status'],
          id: payment_info['id'])
       end
      else
        puts "Something is up! Check this response code: #{response.code}"
      end
    end

    private
    def call_api(url_extension:, request:, body:nil)
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
      if response.code == 200
        @token = JSON.parse(response.body)["token"]
      else
        puts "Something is up! Check this response code: #{response.code}"
      end
    end
  end
end
