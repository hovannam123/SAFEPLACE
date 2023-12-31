# frozen_string_literal: true

CarrierWave.configure do |config|
  config.fog_credentials = {
    provider: 'AWS', # required
    aws_access_key_id: ENV['ACCESS_KEY_ID'], # required unless using use_iam_profile
    aws_secret_access_key: ENV['SECRET_KEY_ID'], # required unless using use_iam_profile
    region: 'ap-southeast-1' # corrected region value
  }
  config.fog_directory  = 'safeplaceproject' # required
  config.fog_public     = false                                                 # optional, defaults to true
  config.fog_attributes = { cache_control: "public, max-age=#{365.days.to_i}" } # optional, defaults to {}
  # For an application that utilizes multiple servers but does not need caches persisted across requests,
  # uncomment the line :file instead of the default :storage.  Otherwise, it will use AWS as the temp cache store.
  # config.cache_storage = :file
end
