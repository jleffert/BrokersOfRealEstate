module BORE
  class Sync_objects
    def self.sync_media
      rets = RubyRETS::RETS.new(ENV["RETS_USER_ID"], ENV["RETS_PASSWORD"], ENV["RETS_USER_AGENT"], 'http://rets172lax.raprets.com:6103')
      properties = rets.search('VirtualMedia', 'Pic','(MediaType=|Pic)', '/Midlands/MIDL/getobject.aspx')
      
    end
  end
end