# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "actioncable"

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user
    rescue_from(ArgumentError) { |exception| exception.message }
  end

  class Channel < ActionCable::Channel::Base
  end
end

class ChatChannel < ApplicationCable::Channel
  periodically :refresh, every: 5
  rescue_from(ArgumentError) { |exception| exception.message }

  private

  def refresh
  end
end

ChatChannel.broadcast_to("room", { body: "hi" })
ChatChannel.channel_name
