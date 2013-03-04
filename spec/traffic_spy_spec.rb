require 'spec_helper'
require 'rack/test'

#set :environment, :development

def app
  #Sinatra::Application
  TrafficSpy::Server
end

describe "Traffic Spy App" do
	include Rack::Test::Methods

	let(:client) { TrafficSpy::Client }
	let(:url) { TrafficSpy::Url }

	before do
    #TODO create a method for deleting
    TrafficSpy::DB["DELETE FROM clients"].delete

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
        client.new(identifier: "id", root_url: "url").save

        post '/sources', params = {identifier: 'id', rootUrl:'url'}
        expect(last_response).to be_forbidden
      end

      it "returns a a message with the forbidden status" do
        TrafficSpy::Client.new(identifier: "id", root_url: "url").save
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
        expect(clients_table.count).to eq 1

      end

      it "it returns a json object with the identifier" do
        post '/sources', params = {identifier: 'id', rootUrl:'url'}
        json = JSON.parse last_response.body

        expect(json["identifier"]).to eq "id"

      end
    end
  end

  describe "processing requests" do

    context "missing payload" do
      it "returns a 400 Bad Request" do
        post '/sources/IDENTIFIER/data'
        expect(last_response).to be_bad_request
      end
      it "returns a descriptive message" do
        post '/sources/IDENTIFIER/data'
        expect(last_response.body).to_not be_empty
      end
    end

    context "unique payload" do

        let(:payload) do 
          { url:"http://jumpstartlab.com/blog",
          requestedAt:"2013-02-16 21:38:28 -0700",
          respondedIn:37,
          referredBy:"http://jumpstartlab.com",
          requestType:"GET",
          parameters:[],
          eventName: "socialLogin",
          userAgent:"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
          resolutionWidth:"1920",
          resolutionHeight:"1280",
          ip:"63.29.38.211" }.to_json
        end


      it "returns a 200 ok status" do
        post '/sources/indentifier/data', {payload: payload}
        # expect(last_response).to be_ok
        pending
      end

      it "adds the URL to the database" do
        # post '/sources/indentifier/data', {payload: payload}
        # expect(TrafficSpy::Url.find_by_id 1).to_not be_nil
        # expect(TrafficSpy::Url.find_by_id(1).url).to eq payload[:url]
        pending
      end

      #3. post
      #4. check ALL THE THINGS )(one at a time)
  end

  describe "url statistics" do

    context "identifier does not exist" do
      it "returns a message that the URL hasn't been requested" do
        post '/sources/IDENTIFIER/urls/data'
        expect(last_response).to_not be_empty
      end
    end

    context "identifier exists" do
       it "returns a query of longest response time to shortest" do
         post '/sources/IDENTIFIER/urls/RELATIVE/PATH'
         expect(TrafficSpy::Url.response_query).to_not be_nil
        # pending
      end
    end

    context "identifier exists" do
       it "returns a query of the average length of response time per url" do
         post '/sources/IDENTIFIER/urls/RELATIVE/PATH'
         expect(TrafficSpy::Url.average_response_time).to_not be_nil
        # pending
      end
    end

  end

end
end
