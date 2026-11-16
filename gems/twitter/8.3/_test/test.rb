require "twitter"

client = Twitter::REST::Client.new do |config|
  config.consumer_key = "consumer-key"
  config.consumer_secret = "consumer-secret"
  config.access_token = "access-token"
  config.access_token_secret = "access-secret"
  config.bearer_token = "bearer"
  config.proxy = { host: "proxy.example.com", port: 8080 }
  config.dev_environment = "dev"
  config.user_agent = "TestAgent/1.0"
  config.timeouts = { connect: 5, read: 10, write: 10, upload: 20.5 }
end

client = Twitter::REST::Client.new(
  consumer_key: "key",
  consumer_secret: "secret",
  user_agent: "TwitterRubyGem/#{Twitter::Version} (https://example.com)",
  timeouts: { connect: 5, read: 5, write: 5 }
)

# Twitter::Client configuration
# @type var token: String?
token = client.access_token
# @type var token_secret: String?
token_secret = client.access_token_secret
# @type var key: String?
key = client.consumer_key
# @type var secret: String?
secret = client.consumer_secret
# @type var proxy: { host: String, port: Integer, ?username: String, ?password: String }?
proxy = client.proxy
# @type var timeouts: { connect: Numeric, read: Numeric, write: Numeric, ?upload: Numeric } | { upload: Numeric } | nil
timeouts = client.timeouts
# @type var environment: String?
environment = client.dev_environment
# @type var bearer: String?
bearer = client.bearer_token
# @type var agent: String
agent = client.user_agent
# @type var credentials: { consumer_key: String?, consumer_secret: String?, token: String?, token_secret: String? }
credentials = client.credentials
client.proxy = { host: "proxy.example.com", port: 8080, username: "user", password: "pass" }
client.timeouts = { upload: 30 }
client.user_token?.itself
client.credentials?.itself
client.bearer_token?.itself

# Twitter::Version
# @type var major: Integer
major = Twitter::Version.major
# @type var minor: Integer
minor = Twitter::Version.minor
# @type var patch: Integer
patch = Twitter::Version.patch
pre = Twitter::Version.pre
pre&.upcase
Twitter::Version.to_h.fetch(:major)
Twitter::Version.to_a.first
Twitter::Version.to_s.upcase

# These calls send requests to the Twitter API, so they are only defined here.
def call_rest_api(client)
  # Tweets
  # @type var tweet: Twitter::Tweet
  tweet = client.update("Hello")
  tweet = client.update!("Hello", in_reply_to_status_id: 1)
  tweet = client.status(27558893223)
  tweet = client.status("https://twitter.com/gem/status/27558893223", tweet_mode: "extended")
  tweet = client.update_with_media("photo", File.open(__FILE__))
  tweet = client.update_with_media("photos", [File.open(__FILE__), File.open(__FILE__)], lang: "ja")
  # @type var tweets: Array[Twitter::Tweet]
  tweets = client.statuses(1, 2, 3)
  tweets = client.statuses(1, "2", tweet, trim_user: true)
  tweets = client.retweets(tweet, count: 10)
  tweets = client.retweet(1, 2)
  tweets = client.retweet(tweet, trim_user: true)
  tweets = client.retweet!(1)
  tweets = client.retweet!(1, trim_user: true)
  tweets = client.unretweet(1)
  tweets = client.unretweet(1, trim_user: true)
  tweets = client.destroy_status(1)
  tweets = client.destroy_status(1, 2, trim_user: true)
  tweets = client.destroy_tweet(1)
  tweets = client.destroy_tweet(1, trim_user: true)
  client.retweet(1).first&.text&.upcase
  # @type var retweeter_ids: Twitter::Cursor[Integer]
  retweeter_ids = client.retweeters_ids(1)
  retweeter_ids = client.retweeters_ids(1, stringify_ids: true)
  retweeter_ids = client.retweeters_ids(stringify_ids: true)

  # Timelines
  tweets = client.mentions_timeline
  tweets = client.mentions(count: 5)
  tweets = client.user_timeline
  tweets = client.user_timeline("gem")
  tweets = client.user_timeline(213747670, count: 5)
  tweets = client.home_timeline
  tweets = client.home_timeline(count: 5)
  tweets = client.retweeted_by_user("gem")
  tweets = client.retweeted_by("gem", count: 5)
  tweets = client.retweeted_by_me
  tweets = client.retweeted_to_me
  tweets = client.retweets_of_me

  # Users
  # @type var user: Twitter::User
  user = client.verify_credentials
  user = client.verify_credentials(skip_status: true)
  user = client.user
  user = client.user("gem")
  user = client.user(213747670, include_entities: false)
  user = client.update_profile(name: "name")
  user = client.update_profile_image(File.open(__FILE__))
  # @type var users: Array[Twitter::User]
  users = client.users("gem", 213747670)
  users = client.users("gem", include_entities: false)
  users = client.user_search("gem")
  users = client.user_search("gem", count: 5)
  users = client.blocked
  users = client.blocked(count: 5)
  users = client.block("gem")
  users = client.block("gem", 213747670, skip_status: true)
  users = client.unblock("gem")
  users = client.unblock("gem", skip_status: true)
  users = client.mute("gem")
  users = client.mute("gem", skip_status: true)
  users = client.unmute("gem")
  users = client.unmute("gem", skip_status: true)
  users = client.muted
  users = client.muted(count: 5)
  client.user?("gem").itself
  client.user?(213747670, include_entities: false).itself
  client.block?("gem").itself
  client.block?(user, include_entities: false).itself
  # @type var user_ids: Twitter::Cursor[Integer]
  user_ids = client.blocked_ids
  user_ids = client.blocked_ids("gem")
  user_ids = client.blocked_ids(user, stringify_ids: true)
  user_ids = client.muted_ids
  user_ids = client.muted_ids("gem")
  user_ids = client.muted_ids(213747670, stringify_ids: true)

  # Search
  # @type var results: Twitter::SearchResults
  results = client.search("to:justinbieber marry me", result_type: "recent")
  client.search("to:justinbieber marry me", result_type: "recent").take(3).map do |found|
    "#{found.user.screen_name}: #{found.text}"
  end
  client.search("#ruby -rt", lang: "ja").first&.text&.upcase
  results.attrs.fetch(:statuses)
  results.to_h.fetch(:statuses)
  results.to_hash.fetch(:statuses)
  results.rate_limit&.remaining
  results.each { |found| found.text.upcase }
  results.each.next.text.upcase

  # Favorites
  tweets = client.favorites
  tweets = client.favorites("gem", count: 5)
  tweets = client.favorites(213747670)
  tweets = client.favorite(1)
  tweets = client.favorite(1, 2, include_entities: false)
  tweets = client.favorite!(1)
  tweets = client.favorite!(tweet, include_entities: false)
  tweets = client.fav(1)
  tweets = client.fav(1, include_entities: false)
  tweets = client.unfavorite(1)
  tweets = client.unfavorite(1, include_entities: false)
  tweets = client.unfavorite!(1)
  tweets = client.unfavorite!(1, include_entities: false)

  # Friends and followers
  # @type var user_cursor: Twitter::Cursor[Twitter::User]
  user_cursor = client.followers("gem")
  user_cursor = client.followers(213747670)
  user_cursor = client.followers
  user_cursor = client.followers(count: 20)
  user_cursor = client.friends("gem", count: 20)
  user_cursor = client.friends
  user_cursor = client.following("gem")
  user_cursor = client.following(count: 20)
  user_cursor.each { |follower| follower.screen_name.upcase }
  user_cursor.take(5).map(&:name)
  user_cursor.to_h.fetch(:users)
  user_cursor.attrs.fetch(:users)
  user_cursor.to_hash.fetch(:users)
  user_ids = client.friend_ids
  user_ids = client.friend_ids("gem", count: 5)
  user_ids = client.follower_ids
  user_ids = client.follower_ids(213747670)
  user_ids = client.friendships_incoming
  user_ids = client.friendships_outgoing(stringify_ids: true)
  users = client.follow("gem")
  users = client.follow(213747670, "gem", follow: true)
  users = client.follow!("gem")
  users = client.follow!("gem", follow: true)
  users = client.unfollow("gem")
  users = client.unfollow("gem", 213747670)
  client.friendship?("gem", "sferik").itself
  client.friendship?(user, 213747670, include_entities: false).itself
  # @type var no_retweet_ids: Array[Integer]
  no_retweet_ids = client.no_retweet_ids
end

# Models
tweet = Twitter::Tweet.new(
  id: 1,
  text: "text",
  user: { id: 2, screen_name: "gem", name: "Gem" },
  created_at: "Mon Jan 01 00:00:00 +0000 2018",
  entities: {
    hashtags: [{ text: "ruby", indices: [0, 4] }],
    symbols: [{ text: "usd", indices: [5, 9] }],
    user_mentions: [{ id: 3, screen_name: "mention", name: "Mention", indices: [10, 19] }],
    urls: [{ url: "https://t.co/x", expanded_url: "https://example.com/", display_url: "example.com", indices: [20, 34] }]
  }
)
# @type var user: Twitter::User
user = Twitter::User.new(
  id: 2,
  screen_name: "gem",
  name: "Gem",
  created_at: "Mon Jan 01 00:00:00 +0000 2018"
)
# @type var base: Twitter::Base
base = Twitter::Base.new
base = Twitter::Base.new({ id: 1 })
tweet.attrs.fetch(:text)
tweet.to_h.fetch(:text)
tweet.to_hash.fetch(:text)
# @type var id: Integer
id = tweet.id
# @type var text: String
text = tweet.text
text = tweet.full_text
# @type var lang: String?
lang = tweet.lang
tweet.source&.upcase
tweet.in_reply_to_screen_name&.upcase
tweet.in_reply_to_status_id&.succ
tweet.in_reply_to_user_id&.succ
tweet.favorite_count + tweet.quote_count + tweet.reply_count + tweet.retweet_count
# @type var created_at: Time?
created_at = tweet.created_at
created_at&.year
tweet.created?.itself
tweet.user.screen_name.upcase
tweet.retweeted_status&.text&.upcase
tweet.retweeted_tweet&.text&.upcase
tweet.quoted_status&.text&.upcase
tweet.quoted_tweet&.text&.upcase
tweet.retweet?.itself
tweet.quote?.itself
tweet.reply?.itself
tweet.favorited?.itself
tweet.retweeted?.itself
tweet.truncated?.itself
tweet.possibly_sensitive?.itself
tweet.uri&.host
tweet.url&.host
tweet.entities?.itself
tweet.hashtags.map { |hashtag| hashtag.text.upcase }
tweet.hashtags?.itself
tweet.symbols.map { |symbol| symbol.text.upcase }
tweet.symbols?.itself
tweet.user_mentions.map { |mention| mention.screen_name + mention.name + mention.id.to_s }
tweet.user_mentions?.itself
tweet.uris.each do |uri|
  uri.expanded_uri&.host
  uri.expanded_url&.host
  uri.uri&.host
  uri.url&.host
  uri.display_uri&.upcase
  uri.display_url&.upcase
  uri.indices.first&.succ
end
tweet.urls.map(&:indices)
tweet.uris?.itself
tweet.urls?.itself

user.id.succ
user.screen_name.upcase
user.name.upcase
user.description&.upcase
user.location&.upcase
user.lang&.upcase
user.time_zone&.upcase
user.utc_offset&.succ
user.favourites_count + user.favorites_count + user.followers_count + user.friends_count
user.listed_count + user.statuses_count + user.tweets_count
user.created_at&.year
user.following?.itself
user.protected?.itself
user.verified?.itself
user.status&.text&.upcase
user.tweet&.text&.upcase
user.tweet?.itself
user.uri&.host
user.url&.host
user.website&.host

# Twitter::Error
def rescue_errors(client)
  begin
    client.update("Hello")
  rescue Twitter::Error::AlreadyRetweeted, Twitter::Error::AlreadyFavorited => e
    e.message.upcase
  rescue Twitter::Error::Forbidden, Twitter::Error::Unauthorized => e
    e.code&.succ
  rescue Twitter::Error::TooManyRequests => e
    e.rate_limit.reset_in&.succ
    e.rate_limit.retry_after&.succ
    e.rate_limit.limit&.succ
    e.rate_limit.remaining&.succ
    e.rate_limit.reset_at&.year
  rescue Twitter::Error::ClientError, Twitter::Error::ServerError => e
    e.class.name
  rescue Twitter::Error => e
    case e
    when Twitter::Error::BadRequest, Twitter::Error::NotFound, Twitter::Error::NotAcceptable
      e.message
    when Twitter::Error::RequestEntityTooLarge, Twitter::Error::UnprocessableEntity, Twitter::Error::DuplicateStatus
      e.message
    when Twitter::Error::InternalServerError, Twitter::Error::BadGateway
      e.message
    when Twitter::Error::ServiceUnavailable, Twitter::Error::GatewayTimeout
      e.message
    when Twitter::Error::InvalidMedia, Twitter::Error::MediaInternalError, Twitter::Error::UnsupportedMedia, Twitter::Error::MediaError
      e.message
    when Twitter::Error::TimeoutError
      e.message
    end
  end
end
Twitter::Error::FORBIDDEN_MESSAGES.call("Status is a duplicate.")
Twitter::Error::Code::AUTHENTICATION_PROBLEM +
  Twitter::Error::Code::RESOURCE_NOT_FOUND +
  Twitter::Error::Code::SUSPENDED_ACCOUNT +
  Twitter::Error::Code::DEPRECATED_CALL +
  Twitter::Error::Code::INVALID_OR_EXPIRED_TOKEN +
  Twitter::Error::Code::SSL_REQUIRED +
  Twitter::Error::Code::UNABLE_TO_VERIFY_CREDENTIALS +
  Twitter::Error::Code::OVER_CAPACITY +
  Twitter::Error::Code::INTERNAL_ERROR +
  Twitter::Error::Code::OAUTH_TIMESTAMP_OUT_OF_RANGE +
  Twitter::Error::Code::ALREADY_FAVORITED +
  Twitter::Error::Code::FOLLOW_ALREADY_REQUESTED +
  Twitter::Error::Code::FOLLOW_LIMIT_EXCEEDED +
  Twitter::Error::Code::PROTECTED_STATUS +
  Twitter::Error::Code::OVER_UPDATE_LIMIT +
  Twitter::Error::Code::DUPLICATE_STATUS +
  Twitter::Error::Code::BAD_AUTHENTICATION_DATA +
  Twitter::Error::Code::SPAM +
  Twitter::Error::Code::LOGIN_VERIFICATION_NEEDED +
  Twitter::Error::Code::ENDPOINT_RETIRED +
  Twitter::Error::Code::CANNOT_WRITE +
  Twitter::Error::Code::CANNOT_MUTE +
  Twitter::Error::Code::CANNOT_UNMUTE

# Streaming
streaming = Twitter::Streaming::Client.new do |config|
  config.consumer_key = "consumer-key"
  config.consumer_secret = "consumer-secret"
  config.access_token = "access-token"
  config.access_token_secret = "access-secret"
end

streaming = Twitter::Streaming::Client.new(consumer_key: "key", consumer_secret: "secret")

# These calls open a streaming connection, so they are only defined here.
def call_streaming_api(streaming, user)
  handler = lambda do |object|
    case object
    when Twitter::Tweet
      object.text.upcase
    when Twitter::DirectMessage
      object.text.upcase
      object.sender_id.succ
      object.recipient_id.succ
      object.sender.screen_name.upcase
      object.recipient.screen_name.upcase
      object.created_at&.year
      object.hashtags.size
    when Twitter::Streaming::DeletedTweet
      object.user_id.succ
      object.id.succ
    when Twitter::Streaming::Event
      object.name.to_s
      object.source.screen_name.upcase
      object.target.screen_name.upcase
      target_object = object.target_object
      case target_object
      when Twitter::List
        target_object.name.upcase
        target_object.full_name.upcase
        target_object.slug.upcase
        target_object.mode.upcase
        target_object.description&.upcase
        target_object.member_count + target_object.subscriber_count
        target_object.user.screen_name.upcase
        target_object.uri.host
      when Twitter::Tweet
        target_object.text.upcase
      end
    when Twitter::Streaming::FriendList
      object.sum
    when Twitter::Streaming::StallWarning
      object.code.upcase
      object.message.upcase
      object.percent_full.succ
    end
  end

  streaming.sample do |object|
    puts object.text if object.is_a?(Twitter::Tweet)
  end
  streaming.sample(stall_warnings: true) { |object| handler.call(object) }
  streaming.firehose { |object| handler.call(object) }
  streaming.firehose(count: 10) { |object| handler.call(object) }
  topics = ["coffee", "tea"]
  streaming.filter(track: topics.join(",")) do |object|
    puts object.text if object.is_a?(Twitter::Tweet)
  end
  streaming.site(1, "gem", with: "followings") { |object| handler.call(object) }
  streaming.site(user) { |object| handler.call(object) }
  streaming.user do |object|
    case object
    when Twitter::Tweet
      puts "It's a tweet!"
    when Twitter::DirectMessage
      puts "It's a direct message!"
    when Twitter::Streaming::StallWarning
      warn "Falling behind!"
    end
  end
  streaming.user(replies: "all") { |object| handler.call(object) }
  streaming.before_request { puts "Connected!" }.close
  # @type var before_request: Proc
  before_request = streaming.before_request
  before_request.call
  streaming.close
end
