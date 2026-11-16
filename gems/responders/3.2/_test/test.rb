require "responders"
require "action_controller"

class ApplicationResponder < ActionController::Responder
  include Responders::FlashResponder
  include Responders::HttpCacheResponder
  include Responders::CollectionResponder
end

class TurboResponder < ActionController::Responder
  def to_html
    super
  end

  def to_js
    super
  end

  def to_format
    super
  end

  def custom_behavior
    head(:no_content)
    render(plain: "ok")
    redirect_to("/posts")
    get? || post? || patch? || put? || delete?
  end

  protected

  def navigation_behavior(error)
    if get?
      raise error
    elsif has_errors? && default_action
      render(error_rendering_options.merge(status: self.class.error_status))
    else
      redirect_to(navigation_location, redirect_options)
    end
  end

  def api_behavior
    display(resource, status: :created, location: api_location) unless has_renderer?
    default_render if has_view_rendering?
    display_errors if has_errors?
    resource_errors
    resource_location
    response_overridden?
  end
end

class PostsController < ActionController::Base
  self.responder = ApplicationResponder

  respond_to :html, :json
  respond_to :xml, only: :index
  respond_to :js, except: [:destroy, :update]

  responders :flash, :http_cache
  responders Responders::CollectionResponder

  def index
    # @type var posts: Array[String]
    posts = ["a"]
    respond_with(posts)
  end

  def show
    respond_with("post", location: "/posts", status: :ok) do |format|
      format.any(:html)
    end
  end

  def create
    respond_with(:admin, "post", responder: TurboResponder)
  end
end

PostsController.clear_respond_to

# @type var mimes: Hash[Symbol, Hash[Symbol, Array[Symbol]]]
mimes = PostsController.mimes_for_respond_to
PostsController.mimes_for_respond_to = mimes

# @type var responder_class: singleton(ActionController::Responder)
responder_class = PostsController.responder
PostsController.responder = responder_class

# @type var flash_responders: singleton(ActionController::Responder)
flash_responders = PostsController.responders(:flash)

Responders::FlashResponder.flash_keys = [:notice, :alert]
Responders::FlashResponder.namespace_lookup = true
# @type var keys: Array[Symbol]
keys = Responders::FlashResponder.flash_keys
keys.first
Responders::FlashResponder.namespace_lookup.!

ActionController::Responder.error_status = :unprocessable_entity
ActionController::Responder.redirect_status = :see_other
ActionController::Responder.error_status.to_s
ActionController::Responder.redirect_status.to_s

class ResponderUser
  def run(controller, post)
    # @type var responder: ActionController::Responder
    responder = ActionController::Responder.new(controller, [post], { location: "/" })
    responder.controller.action_name.upcase
    responder.request.path.upcase
    responder.format.to_s
    responder.resources.size
    responder.options.keys
    responder.resource
    responder.respond
    responder.to_html
    responder.to_js
    responder.to_format
    ActionController::Responder.call(controller, [post])
  end
end

ActionController::Responder::DEFAULT_ACTIONS_FOR_VERBS[:post]
