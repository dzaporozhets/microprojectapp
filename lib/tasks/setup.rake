namespace :setup do
  desc 'Create a new credentials.yml.enc, initialize DB encryption keys, and output the Rails master key'

  task :credentials_and_db_encryption => :environment do
    require 'rails'

    # 1. Check if credentials file exists otherwise generate one
    credentials_path = Rails.root.join("config/credentials.yml.enc")

    if File.exist?(credentials_path)
      puts "Error: config/credentials.yml.enc already exists. Aborting task to avoid overwriting existing credentials."
      exit 1
    end

    puts "Creating or opening the credentials.yml.enc..."
    system('EDITOR="cat" rails credentials:edit')

    # 2. Initialize database encryption keys and capture the output
    puts "Initializing database encryption keys..."
    encryption_keys_output = `./bin/rails db:encryption:init`
    encryption_keys_output.gsub!('Add this entry to the credentials of the target environment:', '')
    puts encryption_keys_output

    if encryption_keys_output.strip.empty?
      puts "No encryption keys generated. Please check the Rails output."
      exit 1
    end

    # 3. Read the current credentials
    puts "Reading current credentials..."
    require 'active_support/encrypted_configuration'
    credentials_path = Rails.root.join("config/credentials.yml.enc")
    key_path = Rails.root.join("config/master.key")

    encrypted_config = ActiveSupport::EncryptedConfiguration.new(
      config_path: credentials_path,
      key_path: key_path,
      env_key: 'RAILS_MASTER_KEY',
      raise_if_missing_key: true
    )

    current_credentials = encrypted_config.read || ""

    # 4. Combine current credentials with new encryption keys
    updated_credentials = "#{current_credentials.strip}\n\n#{encryption_keys_output.strip}"

    # 5. Write updated credentials back to credentials.yml.enc
    puts "Updating credentials with new encryption keys..."
    encrypted_config.write(updated_credentials)

    # 6. Output the Rails master key
    if File.exist?(key_path)
      master_key = File.read(key_path).strip
      puts "Rails master key: #{master_key}"
      puts "To set it as an environment variable, use the following command:"

      puts ''
      puts '============= COMPLETED ==============='
      puts ''
      puts "export RAILS_MASTER_KEY=#{master_key}"
    else
      puts "Rails master key could not be found."
    end
  end
end
