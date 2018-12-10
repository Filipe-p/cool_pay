

RSpec.describe CoolPayFp do
  it "has a version number" do
    expect(CoolPayFp::VERSION).not_to be nil
  end

  it "login works with your_username and a super sectre key" do
    expect(Coolpay::Client.new(
      api_url: 'https://coolpay.herokuapp.com/api/login',
      user_name: 'your_username',
      api_key: '5up3r$ecretKey!').token.nil?).to eq(false)
  end

  it "Search for recipients not to be nil" do
    expect(Coolpay::Client.new(
      api_url: 'https://coolpay.herokuapp.com/api/login',
      user_name: 'your_username',
      api_key: '5up3r$ecretKey!').search_recipients).not_to be nil
  end

  it "Search for recipient 'Chi Wan' not to be nil" do
    expect(Coolpay::Client.new(
      api_url: 'https://coolpay.herokuapp.com/api/login',
      user_name: 'your_username',
      api_key: '5up3r$ecretKey!').search_recipients(name: 'Chi Wan')).not_to be nil
  end

  it "Search for recipient 'Chi Wan' and the @name of the first object to equal to 'Chi Wan'" do
    expect(Coolpay::Client.new(
      api_url: 'https://coolpay.herokuapp.com/api/login',
      user_name: 'your_username',
      api_key: '5up3r$ecretKey!').search_recipients(name: 'Chi Wan').first.name).to eq('Chi Wan')
  end

  it "Making a payment will result in a payment object" do
    expect(Coolpay::Client.new(
      api_url: 'https://coolpay.herokuapp.com/api/login',
      user_name: 'your_username',
      api_key: '5up3r$ecretKey!').make_payment(
      amount: 500,
      recipient_id:'9f670df0-8d2a-4e57-a90d-6ae6728c30be',
      currency:'GBP')).to be_a_kind_of(Coolpay::Payment)
  end

    it "Listing payments will result in array that is not nil" do
    expect(Coolpay::Client.new(
      api_url: 'https://coolpay.herokuapp.com/api/login',
      user_name: 'your_username',
      api_key: '5up3r$ecretKey!').list_payments).not_to be nil
  end

    it "Listing payments will result in an array of payment objects" do
    expect(Coolpay::Client.new(
      api_url: 'https://coolpay.herokuapp.com/api/login',
      user_name: 'your_username',
      api_key: '5up3r$ecretKey!').list_payments.first).to be_a_kind_of(Coolpay::Payment)
  end


end
