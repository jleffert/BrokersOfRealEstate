module BORE
  class SyncObjects 
    def self.initial_import
      rets = RubyRETS::RETS.new(ENV["RETS_USER_ID"], ENV["RETS_PASSWORD"], ENV["RETS_USER_AGENT"], 'http://rets172lax.raprets.com:6103')
      response = rets.login('/Midlands/MIDL/login.aspx')

      Lot.all.each do |lot|
        if lot.picture_count and lot.picture_count > 0
          lot.images.destroy_all
          response = rets.download("Property", "Photo", "#{lot.listing_rid}:*", '/Midlands/MIDL/getobject.aspx')

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
        end
      end
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