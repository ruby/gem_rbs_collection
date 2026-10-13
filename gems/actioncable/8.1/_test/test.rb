# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "actioncable"

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user
    rescue_from(ArgumentError) { |exception| exception.message }
    before_command :authorize

    private

    def authorize
    end
  end

  class Channel < ActionCable::Channel::Base
  end
end

class ChatChannel < ApplicationCable::Channel
  periodically :refresh, every: 5
  rescue_from(ArgumentError) { |exception| exception.message }
  after_subscribe :greet

  def subscribed
    stream_from "chat"
    stream_for "room", ->(message) { transmit(message) }
  end

  private

  def refresh
  end

  def greet
  end
end

ChatChannel.broadcast_to("room", { body: "hi" })
ChatChannel.channel_name
