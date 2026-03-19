require 'rails_helper'

RSpec.describe AdminHelper, type: :helper do
  describe '#admin_config_uploads_storage' do
    context 'when S3 is configured' do
      it 'returns AWS S3' do
        allow(Rails.application.config).to receive(:app_settings).and_return(
          aws_s3_bucket: 'my-bucket'
        )

        expect(helper.admin_config_uploads_storage).to eq('AWS S3')
      end
    end

    context 'when local file storage is enabled' do
      it 'returns Local' do
        allow(Rails.application.config).to receive(:app_settings).and_return(
          aws_s3_bucket: nil,
          enable_local_file_storage: true
        )

        expect(helper.admin_config_uploads_storage).to eq('Local')
      end
    end

    context 'when neither S3 nor local storage is configured' do
      it 'returns Disabled' do
        allow(Rails.application.config).to receive(:app_settings).and_return(
          aws_s3_bucket: nil,
          enable_local_file_storage: nil
        )

        expect(helper.admin_config_uploads_storage).to eq('Disabled')
      end
    end
  end
end
