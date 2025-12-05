require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  # Ensures that a master key has been made available in ENV["RAILS_MASTER_KEY"], config/master.key, or an environment
  # key such as config/credentials/production.key. This key is used to decrypt credentials (and other encrypted files).
  # config.require_master_key = true

  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=#{1.year.to_i}"
  }

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.asset_host = "http://assets.example.com"

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for Apache
  # config.action_dispatch.x_sendfile_header = "X-Accel-Redirect" # for NGINX

  # Mount Action Cable outside main process or domain.
  # config.action_cable.mount_path = nil
  # config.action_cable.url = "wss://example.com/cable"
  # config.action_cable.allowed_request_origins = [ "http://example.com", /http:\/\/example.*/ ]

  # Assume all access to the app is happening through a SSL-terminating reverse proxy.
  # Can be used together with config.force_ssl for Strict-Transport-Security and secure cookies.
  config.assume_ssl = true

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = true

  # Log to STDOUT by default
  config.logger = ActiveSupport::Logger.new(STDOUT)
                                       .tap  { |logger| logger.formatter = ::Logger::Formatter.new }
                                       .then { |logger| ActiveSupport::TaggedLogging.new(logger) }

  # Suppress unstructured log lines
  config.log_level = :fatal

  # Prepend all log lines with the following tags.
  config.log_tags = [ :request_id ]

  # Use a different cache store in production.
  config.cache_store = :solid_cache_store

  # Use a real queuing backend for Active Job (and separate queues per environment).
  config.active_job.queue_adapter = :solid_queue
  config.solid_queue.connects_to = { database: { writing: :queue, reading: :queue } }
  # config.active_job.queue_name_prefix = "fizzy_production"

  config.active_storage.service = ENV.fetch("ACTIVE_STORAGE_SERVICE", "local").to_sym

  config.action_mailer.perform_caching = false

  build_placeholder_email = "build@localhost"

  email_address = ENV["FIZZY_EMAIL_ADDRESS"].presence
  email_address ||= build_placeholder_email if ENV["SECRET_KEY_BASE_DUMMY"].present?
  raise "Missing FIZZY_EMAIL_ADDRESS" if email_address.blank?

  email_domain = ENV["FIZZY_EMAIL_DOMAIN"].presence || email_address.split("@", 2).last
  email_domain ||= "example.com" if ENV["SECRET_KEY_BASE_DUMMY"].present?
  raise "Missing FIZZY_EMAIL_DOMAIN and unable to infer domain from FIZZY_EMAIL_ADDRESS" if email_domain.blank?

  smtp_address = ENV["FIZZY_SMTP_ADDRESS"].presence || "smtp.#{email_domain}"
  smtp_port    = (ENV["FIZZY_SMTP_PORT"].presence || 587).to_i
  smtp_auth    = (ENV["FIZZY_SMTP_AUTHENTICATION"].presence || "plain").to_sym
  starttls     = ENV.fetch("FIZZY_SMTP_ENABLE_STARTTLS_AUTO", "true").to_s.downcase != "false"
  email_password = ENV["FIZZY_EMAIL_PASSWORD"].presence
  email_password ||= "build-placeholder" if ENV["SECRET_KEY_BASE_DUMMY"].present?
  raise "Missing FIZZY_EMAIL_PASSWORD" if email_password.blank?

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: smtp_address,
    port: smtp_port,
    domain: email_domain,
    user_name: email_address,
    password: email_password,
    authentication: smtp_auth,
    enable_starttls_auto: starttls,
    openssl_verify_mode: ENV["FIZZY_SMTP_OPENSSL_VERIFY_MODE"].presence
  }.compact

  app_host = ENV["APP_HOST"].presence || email_domain
  app_host ||= "example.com" if ENV["SECRET_KEY_BASE_DUMMY"].present?
  asset_host = app_host.match?(%r{^https?://}) ? app_host : "https://#{app_host}"

  config.action_controller.default_url_options = { host: app_host, protocol: "https" }
  config.action_mailer.default_url_options     = { host: app_host, protocol: "https" }
  config.action_mailer.asset_host              = asset_host
  config.action_mailer.perform_deliveries      = true

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false
  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Don't log any deprecations.
  config.active_support.report_deprecations = false

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # Skip DNS rebinding protection for the default health check endpoint.
  # config.host_authorization = { exclude: ->(request) { request.path == "/up" } }
end
