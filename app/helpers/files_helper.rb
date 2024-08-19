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

  def project_file_field(f)
    f.file_field :project_files,
      multiple: true, required: true,
      accept: allowed_file_types,
      class: "appearance-none file-select w-full
            leading-tight file:mr-5 file:py-2 file:px-4
            file:rounded-md file:border-0
            file:text-sm file:font-medium"
  end
end

