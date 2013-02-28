require 'spec_helper'
require 'rack/test'

set :environment, :development

def app
  Sinatra::Application
end

describe "Traffic Spy App" do
  include Rack::Test::Methods

  before do
    #TODO create a method for deleting
    TrafficSpy::DB["DELETE FROM clients"].delete

    @client_table = TrafficSpy::DB.from(:clients)
  end

  describe "registration" do

    context "missing params" do

      it "returns a 400 bad request status when missing the identifier" do
        post '/sources', params = {rootUrl:'http://something.com'}
        expect(last_response).to be_bad_request
      end

      it "returns a 400 bad request status when missing the rootUrl" do
        post '/sources', params = {identifier:'identifier'}
        expect(last_response).to be_bad_request
      end

      it "returns a message with the bad request status" do
        post '/sources', params = {identifier:'identifier'}
        expect(last_response.body).to_not be_empty
      end

    end

    context "existing identifier" do
      it "returns a 403 Forbidden status" do
        TrafficSpy::Client.new('id', 'url')
        post '/sources', params = {identifier: 'id', rootUrl:'url'}
        expect(last_response).to be_forbidden
      end

      it "returns a a message with the forbidden status" do
        TrafficSpy::Client.new('id', 'url')
        post '/sources', params = {identifier: 'id', rootUrl:'url'}
        expect(last_response.body).to_not be_empty
      end
    end

    context "acceptable request" do
      it "returns a 200 OK status" do
        post '/sources', params = {identifier: 'id', rootUrl:'url'}
        expect(last_response).to be_ok
      end

      it "creates a new Client" do
        post '/sources', params = {identifier: 'id', rootUrl:'url'}
        #TODO find out why this mock doesn't work
        #TrafficSpy::Client.should_receive(:new).with('id', 'url')
        expect(TrafficSpy::DB.from(:clients).count).to eq 1

      end

      it "it returns a json object with the identifier" do
        post '/sources', params = {identifier: 'id', rootUrl:'url'}
        json = JSON.parse last_response.body

        expect(json["identifier"]).to eq "id"

      end
    end
  end
end


