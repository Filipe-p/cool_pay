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
      # Error handle?
    end

    def create_recipient(name:)
      headers = {'Content-Type' => 'application/json',
                 'Authorization' => "Bearer #{@token}"}
      body = {"recipient": {"name": name}}
      json_body = JSON.generate(body)

      response = HTTParty.post 'https://coolpay.herokuapp.com/api/recipients', body: json_body, headers: headers
      #Error handle
      # create a new recipient object?
    end

    def search_recipients(name:nil)
      headers = {'Content-Type' => 'application/json',
                 'Authorization' => "Bearer #{@token}"}

      if name.nil?
        puts '--------------------------------------'
        puts 'name nil'
        response = HTTParty.get 'https://coolpay.herokuapp.com/api/recipients', headers: headers
        puts response.code
        puts JSON.parse(response.body)["recipients"].count
      else
        query = '?name=' + name.gsub(' ', '%20')
        puts '--------------------------------------'
        puts "query #{query}"
        response = HTTParty.get 'https://coolpay.herokuapp.com/api/recipients' + query, headers: headers
        puts response.code
        puts JSON.parse(response.body)["recipients"].count
      end
    end

  end
end
