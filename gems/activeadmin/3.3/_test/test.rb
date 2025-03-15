# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "activeadmin"

class SessionsController < ActiveAdmin::Devise::SessionsController
end

class TestPanel < ActiveAdmin::Views::Panel
  builder_method :test_panel
end

class TestStatusTag < ActiveAdmin::Views::StatusTag
  builder_method :test_status_tag
end
