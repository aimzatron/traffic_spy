require 'spec_helper'
require 'rack/test'

#set :environment, :development

def app
  TrafficSpy::Server
end

describe "Traffic Spy App" do
  include Rack::Test::Methods

  let(:client) { TrafficSpy::Client }
  let(:url) { TrafficSpy::Url }

  before do
    delete_clients
    delete_payloads
    delete_urls
    delete_web_browsers
    delete_screen_resolutions
    delete_events
    delete_operating_systems
    delete_ips

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
        post '/sources', params = {identifier: 'id', rootUrl:'url'}
        post '/sources', params = {identifier: 'id', rootUrl:'url'}
        expect(last_response).to be_forbidden
      end

      it "returns a message with the forbidden status" do
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
        json = JSON.parse last_response.body, :symbolize_names => true
        expect(json[:identifier]).to eq 'id'
      end
    end

  end

  describe "processing requests" do

    let(:payload) do
      { url:"http://jumpstartlab.com/blog",
        requestedAt:"2013-02-16 21:38:28 -0700",
        respondedIn:37,
        referredBy:"http://jumpstartlab.com",
        requestType:"GET",
        parameters:[],
        eventName: "socialLogin",
        userAgent:"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
        resolutionWidth:"1920",
        resolutionHeight:"1280",
        ip:"63.29.38.211" }.to_json
    end

    let(:insert_client) do
      clients_table.insert(root_url: "http://jumpstartlab.com",
                           identifier: "jumpstartlab")
    end

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

      before do
        insert_client
      end

      it "returns a 200 ok status" do
        post '/sources/indentifier/data', {payload: payload}
        expect(last_response).to be_ok
      end

      it "adds the payload to the database" do
        post '/sources/indentifier/data', {payload: payload}
        expect(payloads_table.count).to eq 1
      end
    end

    context "duplicate payload" do

      before {insert_client}

      it "returns a 403 forbidden status" do
        post '/sources/indentifier/data', {payload: payload}
        post '/sources/indentifier/data', {payload: payload}
        expect(last_response).to be_forbidden
      end

      it "does not add a new entry to the db" do
        post '/sources/indentifier/data', {payload: payload}
        post '/sources/indentifier/data', {payload: payload}
        expect(payloads_table.count).to eq 1
      end

    end

  end

  describe "url statistics" do

    context "identifier does not exist" do

      it "returns a message that the URL hasn't been requested" do
        post '/sources/IDENTIFIER/urls/relative/path/i/dont/care/about'
        puts last_response.status
        expect(last_response).to be_ok
      end

    end

    context "identifier exists" do

      it "it can parse the URL correctly" do
        #TODO add stuff to db first
        get '/sources/IDENTIFIER/urls/RELATIVE/PATH'
        pending "need to setup data first? also doesn't test the right thing"

        # test that we can parse the url correctly -> check the status to be ok
        expect(TrafficSpy::Url.average_response_time).to_not be_nil
      end
    end

  end

  describe "application details" do

    it "displays a message when the identifier does not exist" do
      get 'sources/non_exisitent_identifier'
      pending "need to finish this.."
    end

  end

  describe "application events" do

    context "event exists" do
      it "returns a query of events by event_id in order of receipt amt" do
        #TODO add stuff to db first
        get '/sources/identifier/events'

        pending "i don't think this test is right.."
        # test that we can parse the url correctly -> check the status to be ok
        #expect(TrafficSpy::Event.events_received).to_not be_nil
      end

    end

    context "event does not exist" do

      it "returns a message that no events have been defined" do
        #TODO look into cucumber for testing our views??? maybe? somehow?? i'unno
        get '/sources/identifier/events'
        pending "need to setup data"
        #expect(last_response).to_not be_empty
      end

    end

  end

  describe "application event details" do

    context "event name exists" do

      it "returns breakdown hour by hour of when the event was received" do
        #TODO add stuff to db first
        get '/sources/identifier/events/name'
        pending "need to setup data"
        # test that we can parse the url correctly -> check the status to be ok
        #expect(last_response).to_not be_empty
      end

    end

  end

end
