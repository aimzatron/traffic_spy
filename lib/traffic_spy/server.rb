module TrafficSpy
  class Server < Sinatra::Base
    set :view, 'lib/views'

    get '/' do
      erb :index
    end

    not_found do
      erb :error
    end

    def missing_required_source_params?(params)
      params[:identifier].nil? || params[:rootUrl].nil?
    end

    def client_already_exists?(identifier)
      # TOOD: Client.exists?(identifier)
      !DB.from(:clients).select.where(identifier: identifier).empty?
    end

    post '/sources' do
      # client = Client.new params[:identifier], params[:rootUrl]
      # if client.invalid?
      #   halt 400
      # else
      #
      #   client.save
      # end

      if missing_required_source_params?(params)
        halt(400, "Registration incomplete. Missing params.")
      elsif client_already_exists?(params[:identifier])
        halt(403, "An account already exists with this identifier")
      else
        Client.new params[:identifier], params[:rootUrl]
        {identifier: params[:identifier]}.to_json
      end
    end
  end

end
