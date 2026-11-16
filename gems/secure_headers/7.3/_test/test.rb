require "secure_headers"
require "action_controller"
require "action_view"

SecureHeaders::Configuration.default do |config|
  config.csp = {
    default_src: %w['self' https:],
    script_src: %w['self' js.example.com],
    style_src: %w['self' 'unsafe-inline'],
    img_src: %w[* data: blob:],
    frame_ancestors: %w['none'],
    base_uri: %w['self'],
    upgrade_insecure_requests: true,
    sandbox: true,
    report_uri: %w[https://report.example.com/csp]
  }
  config.csp_report_only = {
    default_src: %w['self'],
    report_only: true
  }
  config.cookies = {
    secure: true,
    httponly: true,
    samesite: { lax: true }
  }
  config.hsts = "max-age=#{20 * 365 * 24 * 60 * 60}"
  config.x_frame_options = "DENY"
  config.x_content_type_options = "nosniff"
  config.x_xss_protection = "1; mode=block"
  config.x_download_options = "noopen"
  config.x_permitted_cross_domain_policies = "none"
  config.referrer_policy = %w[origin-when-cross-origin strict-origin-when-cross-origin]
  config.clear_site_data = ["cache", "cookies"]
  config.expect_certificate_transparency = {
    enforce: true,
    max_age: 86_400,
    report_uri: "https://report.example.com/ct"
  }
  config.reporting_endpoints = { "csp-endpoint" => "https://report.example.com/reports" }
end

class ConfigExamples
  def opt_outs
    SecureHeaders::Configuration.configure do |config|
      config.csp = SecureHeaders::OPT_OUT
      config.csp_report_only = SecureHeaders::OPT_OUT
      config.hsts = SecureHeaders::OPT_OUT
      config.x_frame_options = SecureHeaders::OPT_OUT
      config.x_xss_protection = SecureHeaders::OPT_OUT
      config.x_download_options = SecureHeaders::OPT_OUT
      config.x_permitted_cross_domain_policies = SecureHeaders::OPT_OUT
      config.referrer_policy = SecureHeaders::OPT_OUT
      config.clear_site_data = true
      config.cookies = SecureHeaders::OPT_OUT
      config.cookies = {
        secure: SecureHeaders::OPT_OUT,
        httponly: { only: ["session_id"] },
        samesite: { lax: { except: ["tracker"] }, strict: { only: ["tracker"] } }
      }
      config.cookies = { samesite: SecureHeaders::OPT_OUT }
    end
  end

  def mutate_default
    SecureHeaders::Configuration.default do |config|
      config.csp[:default_src] = []
      config.csp[:script_src] = ["'self'"]
      config.csp[:connect_src] = ["wss://cable.example.com"]
      config.csp_report_only[:script_src] = ["'self'"]
      config.csp_report_only = config.csp.merge({ report_only: true, report_uri: ["https://report.example.com/csp"] })
      config.csp = config.csp.merge({ img_src: ["data:"] })
      # @type var dynamic_csp: Hash[Symbol, untyped]
      dynamic_csp = {}
      dynamic_csp[:default_src] = ["'self'"]
      config.csp = dynamic_csp
      config.csp = config.csp.merge(dynamic_csp)
      # @type var dynamic_cookies: Hash[Symbol, untyped]
      dynamic_cookies = { secure: true }
      config.cookies = dynamic_cookies
    end
  end

  def disable
    SecureHeaders::Configuration.disable!
  end
end

SecureHeaders::Configuration.override(:api) do |config|
  config.csp = SecureHeaders::OPT_OUT
end

SecureHeaders::Configuration.named_append(:widgets) do |request|
  { script_src: ["#{request.scheme}://widgets.example.com"] }
end

disabled = SecureHeaders::Configuration.disabled? # @type var disabled: bool?

# A Configuration is created by Configuration.default, so these calls are not run here
# @type var read_config: ^(SecureHeaders::Configuration) -> void
read_config = lambda do |copy3|
  hsts = copy3.hsts # @type var hsts: String | SecureHeaders::NoOpHeaderConfig | nil
  xfo = copy3.x_frame_options # @type var xfo: String | SecureHeaders::NoOpHeaderConfig | nil
  copy3.x_content_type_options
  copy3.x_xss_protection
  copy3.x_download_options
  copy3.x_permitted_cross_domain_policies
  copy3.referrer_policy
  copy3.clear_site_data
  copy3.expect_certificate_transparency
  copy3.reporting_endpoints
  copy3.cookies
  csp = copy3.csp # @type var csp: SecureHeaders::ContentSecurityPolicyConfig
  report_only = copy3.csp_report_only # @type var report_only: SecureHeaders::ContentSecurityPolicyReportOnlyConfig | SecureHeaders::NoOpHeaderConfig
end

opt_out = SecureHeaders::OPT_OUT
opt_out_flag = opt_out.opt_out? # @type var opt_out_flag: true
opt_out_hash = opt_out.to_h # @type var opt_out_hash: Hash[untyped, untyped]
opt_out_dup = opt_out.dup # @type var opt_out_dup: SecureHeaders::NoOpHeaderConfig

policy = SecureHeaders::ContentSecurityPolicyConfig.new({ default_src: ["'self'"] })
# @type var script_src: untyped
script_src = policy[:script_src]
policy[:script_src] = ["'self'"]
merged = policy.merge({ img_src: ["data:"] }) # @type var merged: SecureHeaders::ContentSecurityPolicyConfig
policy.merge!({ font_src: ["data:"] })
policy.append({ script_src: ["js.example.com"] })
policy_hash = policy.to_h # @type var policy_hash: SecureHeaders::csp_directives
policy_copy = policy.dup # @type var policy_copy: SecureHeaders::ContentSecurityPolicyConfig
policy_opt_out = policy.opt_out? # @type var policy_opt_out: false
policy_report_only = policy.report_only? # @type var policy_report_only: bool
policy_made = policy.make_report_only # @type var policy_made: SecureHeaders::ContentSecurityPolicyReportOnlyConfig
same = policy == policy_copy # @type var same: bool
report_only_policy = SecureHeaders::ContentSecurityPolicyReportOnlyConfig.new({ default_src: ["'self'"] })
report_only_policy.report_only?

class RackLikeRequest
  def env
    @env ||= {}
  end

  def scheme
    "https"
  end
end

class NilSchemeRequest
  def env
    @env ||= {}
  end

  def scheme
    nil
  end
end

request = RackLikeRequest.new

begin
  SecureHeaders.override_content_security_policy_directives(request, { script_src: ["js.example.com"] })
  SecureHeaders.override_content_security_policy_directives(request, { frame_ancestors: ["'self'"] }, :enforced)
  SecureHeaders.append_content_security_policy_directives(request, { script_src: ["js.example.com"] })
  SecureHeaders.append_content_security_policy_directives(request, { style_src: ["'unsafe-inline'"] }, :report_only)
  SecureHeaders.use_content_security_policy_named_append(request, :widgets)
  SecureHeaders.override_x_frame_options(request, "sameorigin")
  SecureHeaders.opt_out_of_header(request, :csp)
  SecureHeaders.opt_out_of_all_protection(request)
  SecureHeaders.use_secure_headers_override(request, :api)
  SecureHeaders.opt_out_of_all_protection(NilSchemeRequest.new)
  script_nonce = SecureHeaders.content_security_policy_script_nonce(request) # @type var script_nonce: String
  style_nonce = SecureHeaders.content_security_policy_style_nonce(request) # @type var style_nonce: String
rescue SecureHeaders::Configuration::NotYetConfiguredError, SecureHeaders::Configuration::AlreadyConfiguredError
  nil
rescue SecureHeaders::Configuration::IllegalPolicyModificationError, SecureHeaders::ContentSecurityPolicyConfigError, SecureHeaders::CookiesConfigError
  nil
end

class SecureController < ActionController::Base
  def index
    override_content_security_policy_directives(frame_ancestors: ["'self'", "https://embed.example.com"])
    append_content_security_policy_directives(script_src: ["js.example.com"])
    use_content_security_policy_named_append(:widgets)
    use_secure_headers_override(:api)
    override_x_frame_options("DENY")
    opt_out_of_header(:x_frame_options)
    script_nonce = content_security_policy_script_nonce # @type var script_nonce: String
    style_nonce = content_security_policy_style_nonce # @type var style_nonce: String
    # @type var config: SecureHeaders::Configuration
    config = override_content_security_policy_directives(script_src: ["#{script_nonce}#{style_nonce}"])
    config.csp
  end
end

class SecureView < ActionView::Base
  def render_tags
    # @type var tag: String
    tag = nonced_javascript_tag("console.log(1)")
    tag = nonced_javascript_tag(type: "module") { "console.log(1)" }
    tag = nonced_style_tag("body { margin: 0 }")
    tag = nonced_style_tag(media: "print") { "body { margin: 0 }" }
    tag = nonced_stylesheet_link_tag("application", media: "all")
    tag = nonced_javascript_include_tag("application", "data-turbo-track": "reload")
    tag = nonced_javascript_pack_tag("application")
    tag = nonced_stylesheet_pack_tag("application")
    tag = hashed_javascript_tag { "console.log(1)" }
    tag = hashed_javascript_tag(false) { "console.log(1)" }
    tag = hashed_style_tag(true) { "body { margin: 0 }" }
    nonce = content_security_policy_nonce(:script) # @type var nonce: String
    nonce = content_security_policy_nonce(:style)
    nonce = content_security_policy_script_nonce
    nonce = content_security_policy_style_nonce
    "#{tag}#{nonce}"
  end
end

begin
  nil
rescue SecureHeaders::ViewHelpers::UnexpectedHashedScriptException
  nil
end

# @type var version: String
version = SecureHeaders::VERSION
