module BORE
  class SyncRets
    def self.initial_import
      rets = RubyRETS::RETS.new(ENV["RETS_USER_ID"], ENV["RETS_PASSWORD"], ENV["RETS_USER_AGENT"], 'http://rets172lax.raprets.com:6103')
      response = rets.login('/Midlands/MIDL/login.aspx')

      unless response == RubyRETS::Unauthorized
        properties = rets.search('Property', 'Residential','(City=|Lincoln),(MlsStatus=|A)', '/Midlands/MIDL/search.aspx', { limit: 1 })

        properties.parsed["Residential"]["Property"].each do |property|
          puts property.inspect
        end
      end
    end

    private
    def login
      
    end
  end
end