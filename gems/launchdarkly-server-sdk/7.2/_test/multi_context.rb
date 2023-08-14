# https://docs.launchdarkly.com/sdk/features/user-context-config#ruby
multi_context = LaunchDarkly::LDContext.create_multi([
    LaunchDarkly::LDContext.with_key("user-key-123abc"),
    LaunchDarkly::LDContext.with_key("device-key-123abc", "device"),
])
