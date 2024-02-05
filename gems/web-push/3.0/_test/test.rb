# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "web-push"
require "json"

# One-time, on the server
vapid_key = WebPush.generate_key

# Save these in your application server settings
vapid_key.public_key
vapid_key.private_key

# Or you can save in PEM format if you prefer
vapid_key.to_pem

message = {
  title: "Example",
  body: "Hello, world!",
  icon: "https://example.com/icon.png"
}

WebPush.payload_send(
  endpoint: "https://fcm.googleapis.com/gcm/send/eah7hak....",
  message: JSON.generate(message),
  p256dh: "BO/aG9nYXNkZmFkc2ZmZHNmYWRzZmFl...",
  auth: "aW1hcmthcmFpa3V6ZQ==",
  ttl: 600, # optional, ttl in seconds, defaults to 2419200 (4 weeks)
  urgency: 'normal' # optional, it can be very-low, low, normal, high, defaults to normal
)
