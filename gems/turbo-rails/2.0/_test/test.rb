# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "turbo-rails"

class Message < ActiveRecord::Base
  broadcasts_to :board
  broadcasts_refreshes_to ->(message) { [message, :messages] }

  def board
    "board"
  end

  def target_name
    self.class.broadcast_target_default
  end

  def quietly_count
    self.class.suppressing_turbo_broadcasts { 1 + 1 }
  end

  def suppressed?
    self.class.suppressed_turbo_broadcasts? || suppressed_turbo_broadcasts? ? true : false
  end

  def announce
    broadcast_replace_to board, partial: "messages/message"
    broadcast_action_to board, action: :append, attributes: { method: :morph }
    broadcast_refresh_later
  end

  def announce_later
    broadcast_append_later_to board, target: "messages"
    broadcast_action_later action: :prepend
  end

  def render_later
    broadcast_render_later_to board, partial: "messages/message"
  end
end

class MessagesController < ActionController::Base
  def create
    recede_or_redirect_to "/messages", notice: "Created"
  end

  def update
    refresh_or_redirect_back_or_to "/messages"
  end

  def native?
    hotwire_native_app? && turbo_native_app?
  end
end
