# CoolPayFp

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/cool_pay_fp`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cool_pay_fp'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cool_pay_fp

## Usage

Load the gem either with bundler (not yet available for security reasons)
  gem 'cool_pay_fp'

Require it into one of your ruby 'cool_pay_fp'

Load it in IRB. This might be the easiest.
1 - From the lib folder enter irb
2 - require_relative 'cool_pay_fp'
3 - login to create a user and then make payments

Login with
    Coolpay::Client.new(api_url:, user_name:, api_key:)
example:
    user =Coolpay::Client.new(
          api_url: 'https://coolpay.herokuapp.com/api/login',
          user_name: 'your_username',
          api_key: '5up3r$ecretKey!')

After iniating a user you can interact with the rest of the API through the instance methods.

Seach for Recipients
    search_recipients(name:nil)
example:
    user.search_recipients(name: 'Chi Wan')
    or
    user.search_recipients


Create a Recipient
    create_recipient(name:)
example:
    user.create_recipient(name: 'Alfredo')


Make a Payment:
    make_payment(amount:, recipient_id:, currency:'GBP' )
example:
    user.make_payment(amount:450, recipient_id:'9f670df0-8d2a-4e57-a90d-6ae6728c30be', currency:'GBP' )

List Payments
    list_payments()
example:
    user.list_payments


Test: run the rspec
    $ rspec spec

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/cool_pay_fp. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the CoolPayFp project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/cool_pay_fp/blob/master/CODE_OF_CONDUCT.md).
