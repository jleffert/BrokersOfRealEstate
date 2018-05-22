module BORE
  class SyncObjects 
    def self.import
      rets_session = login_to_rets

      Lot.all.each do |lot|
        if lot.picture_count and lot.picture_count > 0
          property = rets_session[:rets].search('Property', 'RESI',"(ListingRid=#{lot.listing_rid})", '/Midlands/MIDL/search.aspx', { standard_names: 0, select: 'ListingRid,LastModifiedDateTime,PictureModifiedDateTime,PictureCount' })

          if lot.images.empty? or lot.picture_count.to_s != property.parsed.first['PictureCount'] or DateTime.parse(property.parsed.first['PictureModifiedDateTime']) > lot.images.select(:updated_at).order(updated_at: 'desc').first.updated_at
            lot.images.destroy_all
            response = rets_session[:rets].download("Property", "Photo", "#{lot.listing_rid}:*", '/Midlands/MIDL/getobject.aspx')

            s3 = Aws::S3::Resource.new(region:'us-east-1')
            bucket = s3.bucket('brokersofrealestate')
            begin
              response.parsed.each do |image|
                File.rename(image[:data].path, "#{image[:data].path}.jpg")
                image = Image.create(imageable_type: 'Lot', imageable_id: lot.id, url: "#{image[:data].path}.jpg")
                image.upload_to_s3
              end
            rescue *NET_HTTP_RESCUES => e
              puts "ERROR: LOT => #{lot.id}"
              puts "EXCEPTION: #{e}"
            end

            lot.update(picture_count: property.parsed.first['PictureCount'])
          end
        end
      end
    end

    private_class_method
    def self.login_to_rets
      rets = RubyRETS::RETS.new(ENV["RETS_USER_ID"], ENV["RETS_PASSWORD"], ENV["RETS_USER_AGENT"], 'http://rets172lax.raprets.com:6103')
      response = rets.login('/Midlands/MIDL/login.aspx')
      return { response: response, rets: rets }
    end

    NET_HTTP_RESCUES = [ Errno::EINVAL,
      Errno::ECONNRESET,
      EOFError,
      Net::HTTPBadResponse,
      Net::HTTPHeaderSyntaxError,
      Net::ProtocolError,
      Net::OpenTimeout,
      Net::HTTPServerException,
      Net::HTTPFatalError,
      Mechanize::ResponseCodeError,
      OpenSSL::SSL::SSLError,
      Errno::EHOSTUNREACH,
      Mechanize::Error,
      Net::HTTP::Persistent::Error,
      Net::HTTPRetriableError ]
  end
end