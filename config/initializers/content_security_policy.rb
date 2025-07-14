# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy.
# See the Securing Rails Applications Guide for more information:
# https://guides.rubyonrails.org/security.html#content-security-policy-header

Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self, :https
    policy.font_src    :self, :https, :data, "fonts.googleapis.com", "fonts.gstatic.com"
    policy.img_src     :self, :https, :data, :blob
    policy.object_src  :none
    policy.script_src  :self, :https
    policy.style_src   :self, :https, :unsafe_inline, "fonts.googleapis.com"
    policy.connect_src :self, :https, :wss, :ws
    policy.frame_src   :none
    policy.base_uri    :self
    policy.form_action :self
    policy.frame_ancestors :none
    policy.upgrade_insecure_requests true if Rails.env.production?
    
    # Allow Turbo Drive and Stimulus
    policy.script_src :self, :https, :unsafe_eval if Rails.env.development?
    
    # Specify URI for violation reports
    # policy.report_uri "/csp-violation-report-endpoint"
  end

  # Generate session nonces for permitted importmap, inline scripts, and inline styles.
  config.content_security_policy_nonce_generator = ->(request) { SecureRandom.base64(32) }
  config.content_security_policy_nonce_directives = %w(script-src style-src)

  # Report violations without enforcing the policy in development
  config.content_security_policy_report_only = Rails.env.development?
end
