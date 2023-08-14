# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "launchdarkly-server-sdk"

client = LaunchDarkly::LDClient.new("sdk-key-123abc")

context = LaunchDarkly::LDContext.create({ key: "user-key-123abc" })
# @type var show_feature: bool
show_feature = client.variation("flag-key-123abc", {key: "user-key-123abc"}, false)
show_feature = client.variation("flag-key-123abc", context, false)

# @type detail: LaunchDarkly::EvaluationDetail
detail = client.variation_detail("flag-key-123abc", {key: "user-key-123abc"}, false)
detail = client.variation_detail("flag-key-123abc", context, false)

value = detail.value
index = detail.variation_index
reason = detail.reason
