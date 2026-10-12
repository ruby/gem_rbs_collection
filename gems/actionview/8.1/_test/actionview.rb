class Test
  class ApplicationController < ActionController::Base
  end

  class UsersController < ApplicationController
    def create
      render :new, status: :unprocessable_entity
    end

    def update
      render "edit", status: :unprocessable_entity
    end
  end

  class View
    include ActionView::Helpers

    def view_template_form
      form_for @user do |f|
        f.select :country, [ "USA", "Canada", "Mexico" ], include_blank: true
        f.select :country, [ "USA", "Canada", "Mexico" ], include_blank: true do
          "Custom Option"
        end

        f.collection_radio_buttons :country, [ "USA", "Canada", "Mexico" ], :to_s, :to_s
        f.collection_radio_buttons :country, [ "USA", "Canada", "Mexico" ], :to_s, :to_s do |b|
          b.label { b.radio_button }
        end

        f.collection_check_boxes :country, [ "USA", "Canada", "Mexico" ], :to_s, :to_s
        f.collection_check_boxes :country, [ "USA", "Canada", "Mexico" ], :to_s, :to_s do |b|
          b.label { b.check_box }
          b.label
        end

        f.submit
      end

      select :country, [ "USA", "Canada", "Mexico" ], include_blank: true

      select :country, [ "USA", "Canada", "Mexico" ], include_blank: true do
        "Custom Option"
      end

      collection_check_boxes :user, :country, [ "USA", "Canada", "Mexico" ], :to_s, :to_s
      collection_check_boxes :user, :country, [ "USA", "Canada", "Mexico" ], :to_s, :to_s do |b|
        b.label { b.check_box }
      end

      collection_radio_buttons :user, :country, [ "USA", "Canada", "Mexico" ], :to_s, :to_s
      collection_radio_buttons :user, :country, [ "USA", "Canada", "Mexico" ], :to_s, :to_s do |b|
        b.label { b.radio_button }
      end

      label_tag :country, "Country Label"
      label_tag :country, "Country Label" do
        "Custom Label Content"
      end

      button_tag "Click Me"
      button_tag "Click Me" do
        "Custom Button Content"
      end

      form_with url: "/search"

      picture_tag "picture.webp"
      time_tag Date.new(2025, 1, 1)
      weekday_select :user, :weekday
      phone_to "1234567890"
      sms_to "1234567890"
    end
  end

  class CustomView < ActionView::Base
    def view_template_controller
      request.path
      params.permit(:name)
      controller_name.to_sym
      action_name.to_sym
      flash.now
      cookies[:name]
      formats.first
      view_paths.paths
      config.key?(:asset_host)
    end
  end

  class ViewTest < ActionView::TestCase
    def test_render
      render partial: "users/user"
    end
  end
end
