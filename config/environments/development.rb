Rails.application.configure do
  config.cache_classes = false

  config.eager_load = false

  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  config.action_mailer.raise_delivery_errors = false

  config.active_support.deprecation = :log

  config.active_record.migration_error = :page_load

  config.assets.debug = true

  config.assets.raise_runtime_errors = true

  $s5_token = "qgoZfHW1vcb9yZarnAvOeQOyk5uBBzrU"
  $s5_secret = "4XE0nF3JiyK1HZlGGBNFqIMAjUH766Tl"

  $clear_token = "eoGhYXhMtseFNLLiEEJ9CNe5QYo5kYNN"
  $clear_secret = "Srh9SmXchi7RVVT6iIny8RySr7Gidbt1"

  $s5_judge_invite = "http://s5.studentrnd.org/invite/k4gE68XcfuXfymyadrgdgKkfxGV8fRPC"
end
