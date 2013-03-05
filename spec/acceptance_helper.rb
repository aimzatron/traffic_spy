require 'spec_helper'
require 'capybara/rspec'

Capybara.app = app

RSpec.configure do |config|
  config.include Capybara::DSL
end

def selector string
  find :css, string
end
