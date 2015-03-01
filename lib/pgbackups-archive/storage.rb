require "fog/aws"
require "open-uri"

class PgbackupsArchive::Storage

  def initialize(key, file)
    @key = key
    @file = file
  end

  def connection
    Fog::Storage.new({
      :provider              => "AWS",
      :aws_access_key_id     => ENV["PGARCH_AWS_ACCESS_KEY_ID"],
      :aws_secret_access_key => ENV["PGARCH_AWS_SECRET_ACCESS_KEY"],
      :region                => ENV["PGARCH_REGION"],
      :persistent            => false
    })
  end

  def bucket
    connection.directories.get ENV["PGARCH_BUCKET"]
  end

  def store
    bucket.files.create :key => @key, :body => @file, :public => false, :encryption => "AES256"
  end

end
