require "fcm"

GOOGLE_APPLICATION_CREDENTIALS_PATH = '/path/to/credentials.json'
FIREBASE_PROJECT_ID = 'your_project_id'

# HTTP v1 API

fcm = FCM.new(
  GOOGLE_APPLICATION_CREDENTIALS_PATH,
  FIREBASE_PROJECT_ID
)
message = {
  'token': "000iddqd", # send to a specific device
  # 'topic': "yourTopic",
  # 'condition': "'TopicA' in topics && ('TopicB' in topics || 'TopicC' in topics)",
  'data': {
    payload: {
      data: {
        id: 1
      }
    }.to_json
  },
  'notification': {
    title: "title",
    body: "body",
  },
  # 'android': {},
  'apns': {
    payload: {
      aps: {
        sound: "default",
        category: "#{Time.now.to_i}"
      }
    }
  },
  'fcm_options': {
    analytics_label: 'Label'
  }
}

fcm.send_v1(message)
fcm.send_notification_v1(message)

# Generate a Notification Key for device group

key_name = "appUser-Chris"
project_id = "my_project_id"
registration_ids = ["4", "8", "15", "16", "23", "42"]
response = fcm.create(key_name, project_id, registration_ids)

# Send to Notification device group

message = {
  'token': "NOTIFICATION_KEY", # send to a device group
  # ...data
}

fcm.send_v1(message)

# Add/Remove Registration Tokens

key_name = "appUser-Chris"
project_id = "my_project_id"
notification_key = "appUser-Chris-key"
registration_ids = ["7", "3"]
response = fcm.add(key_name, project_id, notification_key, registration_ids)

key_name = "appUser-Chris"
project_id = "my_project_id"
notification_key = "appUser-Chris-key"
registration_ids = ["8", "15"]
response = fcm.remove(key_name, project_id, notification_key, registration_ids)

# Send Messages to Topics

response = fcm.send_to_topic("yourTopic",
            notification: { body: "This is a FCM Topic Message!"} )

# Send Messages to Topics with Conditions

response = fcm.send_to_topic_condition(
  "'TopicA' in topics && ('TopicB' in topics || 'TopicC' in topics)",
  notification: {
    body: "This is an FCM Topic Message sent to a condition!"
  }
)

response = fcm.send_to_topic_condition(
  "'TopicA' in topics && ('TopicB' in topics || 'TopicC' in topics)",
  notification: {
    body: "This is an FCM Topic Message sent to a condition!"
  }
)

# Subscribe the client app to a topic

topic = "YourTopic"
registration_token= "12" # a client registration token
response = fcm.topic_subscription(topic, registration_token)
# or unsubscription
response = fcm.topic_unsubscription(topic, registration_token)

topic = "YourTopic"
registration_tokens= ["4", "8", "15", "16", "23", "42"] # an array of one or more client registration tokens
response = fcm.batch_topic_subscription(topic, registration_tokens)
# or unsubscription
response = fcm.batch_topic_unsubscription(topic, registration_tokens)

# Get Information about the Instance ID

registration_token= "12" # a client registration token
response = fcm.get_instance_id_info(registration_token)

registration_token= "12" # a client registration token
options = { "details" => true }
response = fcm.get_instance_id_info(registration_token, options)
