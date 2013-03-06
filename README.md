# TrafficSpy

Aimee's and Elaine's awesome TrafficSpy.

## Installation

Add this line to your application's Gemfile:

    gem 'traffic_spy'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install traffic_spy

## Usage

### To run TrafficSpy as a web app:
1. In your terminal, create a database
    createdb traffic_spy
2. `rake db:setup`
3. `rake db:migrate`
4. `shotgun`

You only need to run steps 1 - 3 once.

### To run the Tests
Make sure you run the commands with the test environment set
1. `traffic_spy_env=test bundle exec rake db:setup`
2. `traffic_spy_env=test bundle exec rake db:migrate`
3. `traffic_spy_env=test bundle exec gaurd`

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
