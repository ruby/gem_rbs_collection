module Test
  users = User.all

  # @type var to_xml: String
  to_xml = users.to_xml
  # @type var length: Integer
  length = users.length
  # @type var joined: String
  joined = users.join(", ")
  # @type var intersected: bool
  intersected = users.intersect?(User.all)
  # @type var user_at: User?
  user_at = users[0]
  # @type var users_in_range: Array[User]?
  users_in_range = users[0..1]
  # @type var users_from_start: Array[User]?
  users_from_start = users[0, 2]
  # @type var and_users: Array[User]
  and_users = users & User.all
  # @type var or_users: Array[User | Integer]
  or_users = users | [1]
  # @type var plus_users: Array[User | Integer]
  plus_users = users + [1]
  # @type var minus_users: Array[User]
  minus_users = users - User.all
  # @type var sampled_user: User?
  sampled_user = users.sample
  # @type var sampled_users: Array[User]
  sampled_users = users.sample(2)
  # @type var reversed: Array[User]
  reversed = users.reverse
  # @type var rotated: Array[User]
  rotated = users.rotate(1)
  # @type var compacted: Array[User]
  compacted = users.compact
  # @type var groups: Array[Array[User?]]
  groups = users.in_groups(2)
  # @type var groups_with_filler: Array[Array[User | String]]
  groups_with_filler = users.in_groups_of(2, "")
  users.in_groups_of(2) { |group| group.compact.each(&:save!) }
  # @type var sentence: String
  sentence = users.to_sentence
  # @type var formatted: String
  formatted = users.to_fs(:db)
  # @type var formatted_s: String
  formatted_s = users.to_formatted_s
  # @type var json: Array[untyped]
  json = users.as_json
  # @type var shuffled: Array[User]
  shuffled = users.shuffle
  # @type var splitted: Array[Array[User]]
  splitted = users.split { |user| user.persisted? }
  # @type var sliced: Array[User]?
  sliced = users.slice(0, 2)
  # @type var found_index: Integer?
  found_index = users.index { |user| user.persisted? }
  # @type var found_rindex: Integer?
  found_rindex = users.rindex(users.first)

  # @type var article: Article?
  article = User.take.articles[0]
end
