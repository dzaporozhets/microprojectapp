class AvatarUploader < CarrierWave::Uploader::Base
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_allowlist
    %w(jpg jpeg png)
  end

  def size_range
    1..500.kilobytes
  end

  def fog_attributes
    { 'Cache-Control' => 'public, max-age=31536000, immutable' }
  end
end
