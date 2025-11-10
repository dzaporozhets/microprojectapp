# frozen_string_literal: true

# Validates import data and file requirements
class ProjectImportValidator
  MAX_FILE_SIZE = 5.megabytes

  attr_reader :errors

  def initialize(file, data)
    @file = file
    @data = data
    @errors = []
  end

  def valid?
    validate_file_presence
    validate_file_size
    validate_json_structure
    validate_import_limits

    @errors.empty?
  end

  private

  def validate_file_presence
    @errors << 'Please upload a file.' if @file.nil?
  end

  def validate_file_size
    return if @file.nil?

    if @file.size > MAX_FILE_SIZE
      @errors << "File size should be less than #{MAX_FILE_SIZE / 1.megabyte} MB."
    end
  end

  def validate_json_structure
    return unless @data

    validate_array_field('tasks')
    validate_array_field('notes')
  end

  def validate_array_field(field_name)
    field = @data[field_name]
    return if field.nil? && field_name == 'notes' # notes are optional

    unless field.is_a?(Array)
      @errors << "Invalid JSON file format: #{field_name} should be an array."
    end
  end

  def validate_import_limits
    return unless @data

    tasks = @data['tasks'] || []
    notes = @data['notes'] || []

    if tasks.size > max_import_count || notes.size > max_import_count
      @errors << "Too many tasks or notes. Maximum allowed is #{max_import_count} items each."
    end
  end

  def max_import_count
    Task::TASK_LIMIT
  end
end
