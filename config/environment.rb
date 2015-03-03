# Load the Rails application.
require File.expand_path('../application', __FILE__)

def http_get(domain, path, params)
  return Net::HTTP.get(domain, "#{path}?".concat(params.collect { |k,v| "#{k}=#{CGI::escape(v.to_s)}" }.join('&'))) if not params.nil?
  return Net::HTTP.get(domain, path)
end

def http_post(domain, path, params)
  uri = URI.parse(domain)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  request = Net::HTTP::Post.new(path)
  request.add_field('Content-Type', 'application/json')
  request.body = params
  response = http.request(request)
end

# Initialize the Rails application.
Rails.application.initialize!
