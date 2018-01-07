class Image < ApplicationRecord
  belongs_to :imageable, polymorphic: true
  
  after_destroy :delete_s3_image

  def upload_to_s3
    s3 = Aws::S3::Resource.new(region:'us-east-1')
    bucket = s3.bucket('brokersofrealestate')
    object = bucket.object("images/#{imageable_type.downcase.pluralize}/#{imageable.id}/#{File.basename(url)}")
    object.upload_file(url, acl: 'public-read')
    FileUtils.rm(url)
    self.update(url: object.public_url)
  end
  handle_asynchronously :upload_to_s3

  def delete_s3_image
    s3 = Aws::S3::Client.new(region:'us-east-1')
    puts self.url
    s3.delete_object({
      bucket: 'brokersofrealestate',
      key: self.url.gsub('https://brokersofrealestate.s3.amazonaws.com/', '')
    })
  end
end
