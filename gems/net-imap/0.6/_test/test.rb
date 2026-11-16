require "net/imap"
require "date"

# This method connects to a server, so it is only defined here.
def open_connections(config)
  imap = Net::IMAP.new("mail.example.com", port: 993, ssl: true, open_timeout: 10)
  imap2 = Net::IMAP.new("mail.example.com", ssl: { verify_mode: OpenSSL::SSL::VERIFY_PEER })
  plain = Net::IMAP.new("mail.example.com", port: 143, ssl: false, max_response_size: 1024, debug: false)
  plain.starttls(verify_mode: OpenSSL::SSL::VERIFY_PEER)
  imap2.disconnect(timeout: 5)
  plain.disconnect
  Net::IMAP.new("mail.example.com", config: config)
end

version = Net::IMAP::VERSION
port = Net::IMAP::PORT + Net::IMAP::SSL_PORT
version.upcase
port.succ

# This method sends commands to a server, so it is only defined here.
def use_imap(imap)
  # Authentication
  imap.authenticate(:plain, "user@example.com", "password")
  imap.authenticate("XOAUTH2", "user@example.com", "token")
  if imap.auth_capable?(:OAUTHBEARER)
    imap.authenticate(:OAUTHBEARER, "user@example.com", "token")
  end
  login_response = imap.login("user", "password")
  # @type var login_response: Net::IMAP::TaggedResponse
  login_response.name.upcase
  login_response.tag.upcase
  login_response.raw_data.upcase
  login_response.data.text.upcase
  code = login_response.data.code
  code&.name&.upcase
  code&.data

  # Mailboxes
  select_response = imap.select(Net::IMAP.encode_utf7("INBOX"))
  select_response.tag.upcase
  imap.select("INBOX", condstore: true)
  imap.examine("INBOX")
  imap.create("Archive")
  imap.rename("Archive", "Archive2")
  imap.subscribe("Archive2")
  imap.unsubscribe("Archive2")
  imap.delete("Archive2")
  imap.check
  imap.close
  imap.unselect

  mailboxes = imap.list("", "*")
  mailboxes.each do |mailbox|
    mailbox.name.upcase
    mailbox.delim&.upcase
    mailbox.attr.first&.to_s
  end
  imap.lsub("", "*").size

  status = imap.status("INBOX", ["MESSAGES", "UIDNEXT"])
  status&.fetch("MESSAGES", nil)

  # Capabilities
  capabilities = imap.capabilities
  capabilities.include?("SORT")
  imap.capable?(:MOVE)
  imap.capability?("UIDPLUS")
  imap.auth_mechanisms.first&.upcase
  imap.noop
  imap.enable(:utf8)
  imap.enabled?(:utf8)
  imap.tls_verified?
  imap.tls_connected?
  imap.tls_socket?
  imap.ssl_ctx&.verify_mode
  imap.disconnected?
  imap.greeting&.name
  imap.host.upcase
  imap.port.succ
  imap.open_timeout.round
  imap.idle_response_timeout.round
  imap.max_response_size = 4096
  imap.max_response_size = nil

  # Search
  search_result = imap.search(["SINCE", Date.today - 7])
  # @type var search_result: Net::IMAP::SearchResult
  search_result.each_slice(10) { |batch| batch.sum }
  search_result.modseq
  search_result.to_sequence_set.empty?
  uid_result = imap.uid_search(%w[NOT SEEN])
  uid_result.first
  imap.uid_search("ALL").size
  esearch = imap.uid_search(["ALL"], return: [:MIN, :MAX, :COUNT])
  case esearch
  when Net::IMAP::ESearchResult
    esearch.min
    esearch.max
    esearch.count
    esearch.all&.numbers
    esearch.modseq
    esearch.tag
    esearch.uid?
    esearch.uid
    esearch.to_a.sum
    esearch.to_sequence_set.empty?
    esearch.each { |uid| uid.succ }
    esearch.data.size
  when Net::IMAP::SearchResult
    esearch.size
  end

  # Fetch
  fetch_results = imap.fetch(1..3, "UID")
  # @type var fetch_results: Array[Net::IMAP::FetchData]
  fetch_results.each do |data|
    data.seqno.succ
    data.uid&.succ
    data.attr["UID"]
  end
  # @type var body: String?
  body = imap.fetch(5, "BODY.PEEK[]")[0]&.attr&.[]("BODY[]")
  body&.upcase
  imap.fetch([1, 2], ["FLAGS", "RFC822.SIZE"], changedsince: 10)
  imap.fetch(search_result, "ENVELOPE")

  imap.uid_fetch(search_result, "ENVELOPE").each do |fetch_data|
    envelope = fetch_data.envelope
    envelope&.from&.first&.name
    envelope&.subject&.upcase
    envelope&.date
    envelope&.message_id
    envelope&.in_reply_to
    envelope&.to&.map { |address| address.host }
    envelope&.cc
    envelope&.bcc
    envelope&.sender
    envelope&.reply_to
    envelope&.from&.first&.mailbox
    envelope&.from&.first&.route
  end

  imap.uid_fetch((10 + 1)..-1, "FLAGS").each do |data|
    # @type var uid: Integer
    # @type var flags: Array[Symbol]
    uid, flags = data.attr.values_at("UID", "FLAGS")
    uid.succ
    flags.first
    data.flags&.include?(:Seen)
    data.uid == 5
  end
  imap.uid_fetch(10, %w[UID RFC822.SIZE FLAGS INTERNALDATE RFC822.HEADER], partial: 1..500)
  imap.uid_fetch(7, "BODY.PEEK[]").first&.attr&.fetch("BODY[]", nil)

  data = imap.uid_fetch(3, ["RFC822", "RFC822.HEADER", "RFC822.TEXT", "BODYSTRUCTURE", "MODSEQ"]).first
  if data
    data.rfc822&.upcase
    data.rfc822_header&.upcase
    data.rfc822_text&.upcase
    data.rfc822_size&.succ
    data.size&.succ
    data.modseq&.succ
    data.internaldate&.year
    data.internal_date&.year
    data.message&.upcase
    data.header&.upcase
    data.text&.upcase
    data.part(1)&.upcase
    data.attr_upcase.keys
    data.body
    data.body_structure&.multipart?
    data.bodystructure&.media_type&.upcase
  end


  # Body structure
  struct = imap.uid_fetch(1, "BODYSTRUCTURE").first&.bodystructure
  case struct
  when Net::IMAP::BodyTypeMultipart
    struct.parts.each { |part| part.multipart? }
    struct.subtype&.upcase
    struct.param
    struct.disposition&.dsp_type
    struct.disposition&.param
    struct.media_type.upcase
    struct.language
    struct.location
    struct.extension
  when Net::IMAP::BodyTypeText
    struct.lines.succ
    struct.size.succ
    struct.encoding
    struct.md5
    struct.content_id
    struct.description
    struct.subtype
    struct.param
    struct.disposition
    struct.language
    struct.location
    struct.extension
    struct.media_type
  when Net::IMAP::BodyTypeMessage
    struct.envelope.subject
    struct.body.multipart?
    struct.lines.succ
    struct.size.succ
    struct.md5
    struct.content_id
    struct.description
    struct.encoding
    struct.subtype
    struct.param
    struct.disposition
    struct.language
    struct.location
    struct.extension
    struct.media_type
  when Net::IMAP::BodyTypeBasic
    struct.media_type.upcase
    struct.param&.fetch("NAME", nil)
    struct.disposition&.param
    struct.size.succ
    struct.encoding
    struct.md5
    struct.content_id
    struct.description
    struct.subtype
    struct.language
    struct.location
    struct.extension
  end
  struct&.multipart?
  struct&.media_type&.upcase

  # Store, copy, move, expunge
  imap.store(1..3, "+FLAGS", [:Seen])
  imap.store(1, "-FLAGS", [:Seen, "$Label"], unchangedsince: 3)
  imap.uid_store(8, "+FLAGS.SILENT", [:Seen])
  imap.uid_store(search_result, "+FLAGS", [:Deleted]).each { |d| d.attr }
  imap.uid_store(9, "FLAGS", :Seen)
  imap.copy(1..3, "Archive")
  imap.uid_copy(search_result, "Archive")
  imap.move(1, "Archive")
  imap.uid_move(search_result, "Archive")
  expunged = imap.expunge
  case expunged
  when Array
    expunged.sum
  when Net::IMAP::VanishedData
    expunged.uids.numbers
    expunged.earlier
    expunged.to_a
    expunged.each { |uid| uid.succ }
  end
  imap.uid_expunge(search_result)
  imap.uid_expunge([1, 2])
  imap.append("INBOX", "From: a@example.com\r\n\r\nbody", [:Seen], Time.now)
  imap.append("INBOX", "From: a@example.com\r\n\r\nbody")

  # Sort and thread
  imap.sort(["DATE"], ["ALL"], "UTF-8").sum
  imap.uid_sort(["DATE"], %w[NOT SEEN], "US-ASCII").sum
  threads = imap.thread("REFERENCES", ["ALL"], "UTF-8")
  threads.each do |member|
    member.seqno&.succ
    member.children.size
    member.to_sequence_set.empty?
    member.all_seqnos.sum
  end
  imap.uid_thread("ORDEREDSUBJECT", "ALL", "UTF-8").size

  # Responses
  # @type var exists: Integer
  exists = imap.responses["EXISTS"].last
  exists.succ
  imap.responses("UIDVALIDITY").last
  imap.responses("EXISTS") { |all| all.size }
  imap.responses { |all| all.size }
  imap.clear_responses("RECENT")
  imap.clear_responses
  # @type var handler: Net::IMAP::response_handler
  handler = lambda do |response|
    case response
    when Net::IMAP::UntaggedResponse
      response.name.upcase
      response.data
      response.raw_data.upcase
    when Net::IMAP::TaggedResponse
      response.tag.upcase
    when Net::IMAP::ContinuationRequest
      response.data.text.upcase
      response.raw_data.upcase
    end
  end
  imap.add_response_handler(handler)
  imap.add_response_handler { |response| response }
  imap.response_handlers.size
  imap.remove_response_handler(handler)
  Net::IMAP.new("mail.example.com", response_handlers: [handler])

  # IDLE
  idle_response = imap.idle(60) do |response|
    if response.is_a?(Net::IMAP::UntaggedResponse) && response.name == "EXISTS"
      imap.idle_done
    end
  end
  idle_response&.name

  # Logout
  imap.logout
  imap.logout!
  imap.clear_cached_capabilities
  imap.capabilities_cached?
  imap.disconnect unless imap.disconnected?

end

copy = Net::IMAP::FetchData.new(1, { "UID" => 3, "FLAGS" => [:Seen] })
copy.seqno.succ
copy.attr.size
uid_data = Net::IMAP::UIDFetchData.new(3, { "FLAGS" => [:Seen] })
uid_data.uid.succ

# Class methods and data encoding
Net::IMAP.default_port.succ
Net::IMAP.default_tls_port.succ
Net::IMAP.default_imap_port.succ
Net::IMAP.default_imaps_port.succ
Net::IMAP.default_ssl_port.succ
Net::IMAP.decode_utf7("Entw&APw-rfe").upcase
Net::IMAP.encode_date(Date.today).upcase
Net::IMAP.decode_date("17-Jul-1996").year
Net::IMAP.encode_datetime(Time.now).upcase
Net::IMAP.decode_datetime("17-Jul-1996 02:44:25 -0700").year
Net::IMAP.decode_time("17-Jul-1996 02:44:25 -0700").year
Net::IMAP.debug = true
Net::IMAP.debug.!

# Config
config = Net::IMAP.config
config.debug = false
config.debug?
config.open_timeout = 15
config.idle_response_timeout = 10
config.max_response_size = 2048
config.sasl_ir = true
config.enforce_logindisabled = :when_capabilities_cached
config.to_h.keys
custom = Net::IMAP::Config.new(Net::IMAP::Config.global, open_timeout: 5)
custom.update(open_timeout: 6).open_timeout.succ
custom.with(open_timeout: 7).open_timeout.succ
custom.load_defaults(0.6).debug?
Net::IMAP::Config.default.open_timeout.succ

# SequenceSet
set = Net::IMAP::SequenceSet["1:5,10"]
set.string&.upcase
set.to_s.upcase
set.include?(3)
set.empty?
set.valid?
(set | Net::IMAP::SequenceSet.new(7)).numbers.sum
(set - [1, 2]).ranges.size
(set & (1..3)).count
set.to_a.size
set.min
set.max
set.each_number { |n| n.succ }
set.each_number.to_a
mutable = Net::IMAP::SequenceSet.new([1, 2, 3])
mutable.add(4)
mutable << 5
mutable.freeze
Net::IMAP::SequenceSet.empty.empty?
Net::IMAP::SequenceSet.full.string
Net::IMAP::SequenceSet.try_convert([1, 2])
Net::IMAP.SequenceSet("1:3").string
# This method sends commands to a server, so it is only defined here.
def use_sequence_set_and_handle_errors(imap)
  imap.fetch(Net::IMAP::SequenceSet[1, 2, 3], "UID")

  # Errors
  begin
    imap.login("user", "wrong")
  rescue Net::IMAP::NoResponseError, Net::IMAP::BadResponseError, Net::IMAP::ByeResponseError => e
    e.response.name.upcase
    e.response.raw_data.upcase
    e.message.upcase
  rescue Net::IMAP::ResponseParseError => e
    e.string&.upcase
    e.pos&.succ
    e.lex_state
    e.token
    e.parser_class.name
  rescue Net::IMAP::ResponseTooLargeError => e
    e.bytes_read&.succ
    e.literal_size&.succ
    e.max_response_size&.succ
  rescue Net::IMAP::ResponseReadError, Net::IMAP::InvalidResponseError, Net::IMAP::DataFormatError, Net::IMAP::LoginDisabledError => e
    e.message.upcase
  rescue Net::IMAP::InvalidTaggedResponseError => e
    e.state
    e.command
    e.response.tag.upcase
  rescue Net::IMAP::UnknownResponseError => e
    e.response.data
  rescue Net::IMAP::Error => e
    e.message.upcase
  end
end
