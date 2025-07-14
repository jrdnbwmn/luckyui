# frozen_string_literal: true

Rails.application.configure do
  # Additional security headers
  config.force_ssl = true if Rails.env.production?
  
  # Prevent clickjacking
  config.force_ssl = true if Rails.env.production?
  
  # Add additional security headers
  config.middleware.use Rack::Deflater
  
  # Configure secure headers
  config.ssl_options = {
    hsts: {
      expires: 1.year,
      subdomains: true,
      preload: true
    }
  }
end

# Add security headers via middleware
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins Rails.env.production? ? /\Ahttps:\/\/.*\.yourdomain\.com\z/ : "*"
    resource "*", headers: :any, methods: [:get, :post, :patch, :put, :delete, :options, :head]
  end
end if defined?(Rack::Cors)

# Additional security headers
Rails.application.config.middleware.insert_before ActionDispatch::Static, Proc.new { |env|
  [200, {
    'X-Frame-Options' => 'DENY',
    'X-Content-Type-Options' => 'nosniff',
    'X-XSS-Protection' => '1; mode=block',
    'Referrer-Policy' => 'strict-origin-when-cross-origin',
    'Permissions-Policy' => 'camera=(), microphone=(), geolocation=()'
  }, []]
} if Rails.env.production?