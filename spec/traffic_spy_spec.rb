require 'spec_helper'
require 'rack/test'

set :environment, :development

def app
  Sinatra::Application
end

describe "Traffic Spy App" do
  include Rack::Test::Methods

  describe "registration" do

    describe "missing params" do

      it "returns a 400 bad request status when missing the identifier" do
        post '/sources', params = {rootUrl:'http://something.com'}
        expect(last_response).to be_bad_request
      end

      it "returns a 400 bad request status when missing the rootUrl" do
        post '/sources', params = {identifier:'identifier'}
        expect(last_response).to be_bad_request
      end

    end

    describe "existing identifier" do

    end
  end
end


