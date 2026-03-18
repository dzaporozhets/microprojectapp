require 'rails_helper'

RSpec.describe AttachmentUploader do
  it 'inherits from CarrierWave::Uploader::Base' do
    expect(described_class.superclass).to eq(CarrierWave::Uploader::Base)
  end

  describe '#store_dir' do
    it 'returns path based on model class, mounted_as, and model id' do
      model = double('Model', class: Comment, id: 42)
      uploader = described_class.new(model, :attachment)
      expect(uploader.store_dir).to eq('uploads/comment/attachment/42')
    end
  end

  describe '#size_range' do
    it 'allows files from 1 byte to 5 megabytes' do
      uploader = described_class.new
      expect(uploader.size_range).to eq(1..5.megabytes)
    end
  end
end
