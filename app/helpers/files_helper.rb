module FilesHelper
  def allowed_file_types
    %w(
      text/plain
      image/jpeg
      image/gif
      image/png
      application/pdf
      application/msword
      application/vnd.ms-excel
      application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
      application/vnd.openxmlformats-officedocument.wordprocessingml.document
    ).join(',')
  end

  def s3_storage?
    ENV['AWS_S3_BUCKET'].present?
  end
end

