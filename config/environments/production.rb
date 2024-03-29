Rails.application.configure do
  config.cache_classes = true

  config.eager_load = true

  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.serve_static_files = false

  config.assets.js_compressor = :uglifier
  config.assets.compile = false

  config.assets.digest = true

  config.assets.version = '1.0'

  config.log_level = :info

  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify

  config.log_formatter = ::Logger::Formatter.new

  $s5_token = ENV["S5_TOKEN"]
  $s5_secret = ENV["S5_SECRET"]

  $clear_token = ENV["CLEAR_TOKEN"]
  $clear_secret = ENV["CLEAR_SECRET"]

  $s5_judge_invite = ENV["S5_JUDGE_INVITE"]

  config.active_record.dump_schema_after_migration = false
end
