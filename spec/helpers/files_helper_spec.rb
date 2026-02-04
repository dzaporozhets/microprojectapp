require 'rails_helper'

RSpec.describe FilesHelper, type: :helper do
  describe '#s3_storage?' do
    it 'returns true when AWS S3 bucket is configured' do
      allow(Rails.application.config).to receive(:app_settings).and_return(
        aws_s3_bucket: 'my-bucket',
        enable_local_file_storage: false
      )

      expect(helper.s3_storage?).to be true
    end

    it 'returns false when AWS S3 bucket is not configured' do
      allow(Rails.application.config).to receive(:app_settings).and_return(
        aws_s3_bucket: nil,
        enable_local_file_storage: false
      )

      expect(helper.s3_storage?).to be false
    end
  end

  describe '#file_storage_enabled?' do
    it 'returns true when S3 is configured' do
      allow(Rails.application.config).to receive(:app_settings).and_return(
        aws_s3_bucket: 'my-bucket',
        enable_local_file_storage: false
      )

      expect(helper.file_storage_enabled?).to be true
    end

    it 'returns true when local file storage is enabled' do
      allow(Rails.application.config).to receive(:app_settings).and_return(
        aws_s3_bucket: nil,
        enable_local_file_storage: true
      )

      expect(helper.file_storage_enabled?).to be true
    end

    it 'returns true when both S3 and local file storage are configured' do
      allow(Rails.application.config).to receive(:app_settings).and_return(
        aws_s3_bucket: 'my-bucket',
        enable_local_file_storage: true
      )

      expect(helper.file_storage_enabled?).to be true
    end

    it 'returns false when neither S3 nor local file storage is configured' do
      allow(Rails.application.config).to receive(:app_settings).and_return(
        aws_s3_bucket: nil,
        enable_local_file_storage: false
      )

      expect(helper.file_storage_enabled?).to be false
    end
  end
end
