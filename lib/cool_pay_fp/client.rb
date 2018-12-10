module Coolpay

  class Client
    attr_accessor :api_url, :user_name, :api_key, :token

    def initialize(api_url:, user_name:, api_key:)
      @api_url = api_url
      @user_name = user_name
      @api_key = api_key
      login
    end


    def login
      headers = {'Content-Type' => 'application/json'}
      body = {username: @user_name, apikey: @api_key}
      json_body = JSON.generate(body)


      response = HTTParty.post 'https://coolpay.herokuapp.com/api/login', body: json_body, headers: headers

      @token = JSON.parse(response.body)["token"]
    end

    def create_recipient(name:)
      headers = {'Content-Type' => 'application/json',
                 'Authorization' => "Bearer #{@token}"}
      body = {"recipient": {"name": name}}
      json_body = JSON.generate(body)
      puts @token

      response = HTTParty.post 'https://coolpay.herokuapp.com/api/recipients', body: json_body, headers: headers
    end


  end
end
