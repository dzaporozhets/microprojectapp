# frozen_string_literal: true

if Rails.application.config.app_settings[:aws_s3_bucket]
  Rails.application.config.active_storage.service = :amazon
end
