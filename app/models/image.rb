class Image < ApplicationRecord
  belongs_to :imageable, polymorphic: true
  
  after_destroy :delete_s3_image

  def delete_s3_image
    s3 = Aws::S3::Client.new(region:'us-east-1')
    puts self.url
    s3.delete_object({
      bucket: 'brokersofrealestate',
      key: self.url.gsub('https://brokersofrealestate.s3.amazonaws.com/', '')
    })
  end
end
