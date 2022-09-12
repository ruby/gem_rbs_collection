# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "line-bot-api"

client = Line::Bot::Client.new do |config|
  config.channel_id = "sample channel_id"
  config.channel_secret = "sample channel_secret"
  config.channel_token = "sample channel_token"
  config.endpoint = "https://example.com"
  config.blob_endpoint = "https://example.com"
end

sample_messages = [{ type: :text, text: "sample" }]
client.push_message("line_user_id", sample_messages)
client.reply_message("reply_token", sample_messages)
client.multicast("line_user_id", sample_messages)
client.multicast(["line_user_id", "line_user_id2"], sample_messages)
client.narrowcast(sample_messages)

client.leave_group("group_id")
client.leave_room("room_id")

client.get_message_content("identifier")
client.get_profile("user_id")
client.get_group_member_profile("group_id", "user_id")
client.get_room_member_profile("room_id", "user_id")
client.get_follower_ids
client.get_group_member_ids("group_id")
client.get_room_member_ids("room_id")
client.get_group_summary("group_id")
client.get_group_members_count("group_id")
client.get_room_members_count("room_id")
client.get_rich_menus
client.get_rich_menu("rich_menu_id")
client.get_message_delivery_reply("20220101")
client.get_message_delivery_push("20220101")
client.get_message_delivery_multicast("20220101")
client.get_message_delivery_broadcast("20220101")

sample_lich_menu = {
  size: {
    width: 2500,
    height: 1686
  },
  selected: true,
  name: "richmenu name",
  chatBarText: "chart bar text",
  areas: [
    {
      bounds: {
        x: 0,
        y: 0,
        width: 2500,
        height: 1686
      },
      action: {
        type: "message",
        text: "test1"
      }
    }
  ]
}
client.create_rich_menu(sample_lich_menu)
client.validate_rich_menu_object(sample_lich_menu)
client.delete_rich_menu("rich_menu_id")
client.get_user_rich_menu("user_id")
client.get_default_rich_menu
client.set_default_rich_menu("rich_menu_id")
client.unset_default_rich_menu
client.set_rich_menus_alias("rich_menu_id", "rich_menu_alias_id")
client.unset_rich_menus_alias("rich_menu_alias_id")
client.update_rich_menus_alias("rich_menu_id", "rich_menu_alias_id")
client.get_rich_menus_alias("rich_menu_alias_id")
client.get_rich_menus_alias_list
client.link_user_rich_menu("user_id", "rich_menu_id")
client.unlink_user_rich_menu("user_id")
client.bulk_link_rich_menus(["user_id1", "user_id2"], "rich_menu_id")
client.bulk_unlink_rich_menus(["user_id1", "user_id2"])
client.get_rich_menu_image("user_id")
client.create_link_token("user_id")
client.get_quota
client.get_quota_consumption
client.get_number_of_message_deliveries("20220101")
client.get_user_interaction_statistics("request_id")
client.get_number_of_followers("20220101")
client.get_friend_demographics
client.get_bot_info
client.get_webhook_endpoint
client.set_webhook_endpoint("https://example.com")
client.test_webhook_endpoint

sample_liff_app = {
  view: {
      type: "full",
      url: "https://example.com/myservice"
  },
  description: "Service Example",
  features: {
      ble: true,
      qrCode: true
  },
  permanentLinkPattern: "concat",
  scope: ["profile", "chat_message.write"],
  botPrompt: "none"
}
client.get_liff_apps
client.create_liff_app(sample_liff_app)
client.update_liff_app("liff_id", sample_liff_app)
client.delete_liff_app("liff_id")

client.create_user_id_audience({ description: "sample description" })
client.update_user_id_audience({ audienceGroupId: 1000, uploadDescription: "fileName", audiences: [{ id: "line_user_id" }] })
client.create_click_audience({ description: "sample description", requestId: "sample_request_id" })
client.create_impression_audience({ description: "sample description", requestId: "sample_request_id" })
client.rename_audience(1000, "description")
client.delete_audience(1000)
client.get_audience(1000)
client.get_audiences({ page: 1 })
client.get_audience_authority_level
client.update_audience_authority_level("PUBLIC")
client.get_statistics_per_unit(unit: "unit", from: "from", to: "to")
client.get_aggregation_info
client.get_aggregation_list
