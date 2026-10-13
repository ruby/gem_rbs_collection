# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "actioncable"

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user
    rescue_from(ArgumentError) { |exception| exception.message }
    before_command :authorize

    def connect
      reject_unauthorized_connection unless cookies.encrypted[:user_id]
      request.remote_ip
    end

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
    stream_from "chat_#{params[:room]}"
    connection.statistics
    identifier.size
    broadcasting_for("room").size
    channel_name.size
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
ActionCable.server.broadcast("chat", { body: "hi" })
ChatChannel.broadcasting_for("room").size
