module BORE
  class SyncObjects 
    def self.sync_media
      rets = RubyRETS::RETS.new(ENV["RETS_USER_ID"], ENV["RETS_PASSWORD"], ENV["RETS_USER_AGENT"], 'http://rets172lax.raprets.com:6103')
      response = rets.login('/Midlands/MIDL/login.aspx')

      Lot.all.limit(1).each do |lot|
        if lot.picture_count and lot.picture_count > 0
          lot.images.destroy_all
          response = rets.download("Property", "Photo", "#{lot.listing_rid}:*", '/Midlands/MIDL/getobject.aspx')

          s3 = Aws::S3::Resource.new(region:'us-east-1')
          bucket = s3.bucket('brokersofrealestate')
          response.parsed.each do |image|
            File.rename(image[:data].path, "#{image[:data].path}.jpg")
            object = bucket.object("images/lots/#{lot.id}/#{File.basename(image[:data])}.jpg")
            object.upload_file("#{image[:data].path}.jpg", acl: 'public-read')
            Image.create(imageable_type: 'Lot', imageable_id: lot.id, url: object.public_url)
            FileUtils.rm("#{image[:data].path}.jpg")
          end
        end
      end
    end
  end
end