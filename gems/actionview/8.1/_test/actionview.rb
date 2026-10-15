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

class HelperView < ActionView::Base
  def view_template_helpers
    link_to("Home", "/").html_safe?
    button_to("Delete", "/", method: :delete).html_safe?
    content_tag(:div, "content").html_safe?
    tag.div("content", class: "box").html_safe?
    tag.br.html_safe?
    tag("br").html_safe?
    image_tag("logo.png").html_safe?
    javascript_include_tag("application").html_safe?
    safe_join(["a", "b"], ", ").html_safe?
    raw("<b>bold</b>").html_safe?
    sanitize("<b>bold</b>")&.html_safe?
    truncate("long text", length: 4)&.html_safe?
    simple_format("text").html_safe?
    number_to_currency(1234)&.length
    time_ago_in_words(Time.now).length
    dom_id(Object.new).length
    url_for("/").length
    escape_javascript("alert()").length
    content_for(:title)&.html_safe?
    label_tag(:name).html_safe?
    text_field_tag(:name).html_safe?
    options_for_select([1, 2]).html_safe?
    form_with(url: "/").html_safe?
    form_with(url: "/") do |f|
      f.label(:name).html_safe?
      f.text_field(:name).html_safe?
      f.checkbox(:admin).html_safe?
      f.submit.html_safe?
    end
  end
end

  class ViewTest < ActionView::TestCase
    def test_render
      render partial: "users/user"
    end
  end
end

# ClassMethods of the concerns the generated classes include
ActionView::Base.full_sanitizer
ActionView::Helpers::Tags::Base.sanitizer_vendor

class UrlHelperTest < ActionView::TestCase
  tests ActionView::Helpers::UrlHelper
  helper_method :current_user
end
