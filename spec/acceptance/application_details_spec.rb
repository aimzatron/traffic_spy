require 'acceptance_helper'

describe 'Application Details' do

  context 'identifier does not exist' do

    it 'goes to the sources page' do
      visit '/sources/someid'
      page.should have_content 'The account for someid does not exist'
    end
  end

  context 'identifer exists' do

    before do
      TrafficSpy::Client.new(root_url: "http://jumpstartlab.com", identifier: "jumpstartlab").save

      add_dummy_payload url: 'http://jumpstartlab.com/blog/1', ip: 'ip1'
      add_dummy_payload url: 'http://jumpstartlab.com/blog/1', ip: 'ip2'
      add_dummy_payload url: 'http://jumpstartlab.com/blog/1', ip: 'ip3'
      add_dummy_payload url: 'http://jumpstartlab.com/blog/1', ip: 'ip4'
      add_dummy_payload url: 'http://jumpstartlab.com/blog/1', ip: 'ip5'

      add_dummy_payload url: 'http://jumpstartlab.com/blog/2', ip: 'ip1'
      add_dummy_payload url: 'http://jumpstartlab.com/blog/2', ip: 'ip2'
      add_dummy_payload url: 'http://jumpstartlab.com/blog/2', ip: 'ip3'

      add_dummy_payload url: 'http://jumpstartlab.com/blog/3', ip: 'ip1'
      add_dummy_payload url: 'http://jumpstartlab.com/blog/3', ip: 'ip2'

      visit '/sources/jumpstartlab'
    end

    it 'goes to the application details page' do
      page.should have_content "Application Details for jumpstartlab"
    end

  end
end
