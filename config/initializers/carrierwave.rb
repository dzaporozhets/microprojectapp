# frozen_string_literal: true

app_settings = Rails.application.config.app_settings

if app_settings[:aws_s3_bucket]
  CarrierWave.configure do |config|
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      provider:              'AWS',
      aws_access_key_id:     app_settings[:aws_access_key_id],
      aws_secret_access_key: app_settings[:aws_secret_access_key],
      region:                app_settings[:aws_region]
    }
    config.fog_directory  = app_settings[:aws_s3_bucket]
    config.fog_public     = false # Set to true if you want the files to be publicly accessible
    config.storage        = :fog
  end
else
  CarrierWave.configure do |config|
    config.storage = :file
  end
end
