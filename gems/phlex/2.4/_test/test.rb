require "date"
require "phlex"

class Greeting < Phlex::HTML
  def initialize(name:)
    @name = name
  end

  def view_template
    doctype
    html(lang: "en") do
      head do
        meta(charset: "utf-8")
        title { "Greeting" }
        link(rel: "stylesheet", href: "/app.css")
      end
      body(class: ["page", "home"], data: { controller: "greeting" }) do
        h1(id: "title") { "Hello, #{@name}" }
        a(href: "/about", class: "link") { "About" }
        br
        img(src: "/logo.png", alt: "logo")
        ul do
          [1, 2, 3].each { |i| li { i } }
        end
        whitespace
        plain "text"
        whitespace { span { "x" } }
        comment { "note" }
        raw safe("<b>bold</b>")
        raw nil
      end
    end
  end
end

# @type var html: String
html = Greeting.call(name: "world")
html = Greeting.new(name: "world").call
html = Greeting.new(name: "world").call(+"", context: { user: "alice" }, fragments: ["title"])

class Card < Phlex::HTML
  def initialize(title = "Untitled")
    @title = title
  end

  def view_template(&block)
    article(class: "card") do |component|
      component.h2 { @title }
      div(class: "card-body", &block)
      p { render Greeting.new(name: @title) }
    end
  end
end

class Page < Phlex::HTML
  def initialize(items)
    @items = items
  end

  def view_template
    render Card.new("Items") do
      ul do
        @items.each { |item| li { item } }
      end
    end
    render Card
    render [Greeting.new(name: "a"), Greeting.new(name: "b")]
    render -> { plain "lambda" }
    render "string"
    render
    div(&Greeting.new(name: "c"))
  end

  private def around_template
    main do
      super
    end
  end

  private def before_template
    comment { "Start: #{self.class.name}" }
    super
  end

  private def after_template
    super
  end

  private def render?
    true
  end
end

class Merged < Phlex::HTML
  def initialize(**attributes)
    @attributes = attributes
  end

  def view_template(&)
    div(**mix({ class: "base" }, @attributes), &)
    vanish { span { "hidden" } }
    # @type var cls: untyped
    cls = grab(class: :base)
    # @type var captured: String
    captured = capture { span { "x" } }
    captured = capture(1, 2) { |a, b| span { "#{a}#{b}" } }
    tag(:section, id: "s") { p { "dynamic" } }
    tag(:hr)
    fragment("f") { p { "fragment" } }
    flush
    # @type var rendering: bool
    rendering = rendering?
    # @type var ctx: Hash[untyped, untyped]
    ctx = context
    # @type var type: String
    type = content_type
    # @type var name: String?
    name = filename
    # @type var safe_value: Phlex::SGML::SafeValue
    safe_value = safe("<b>")
    safe_value.to_s.upcase
  end
end

class Cached < Phlex::HTML
  def view_template
    cache("key", expires_in: 60) { p { "cached" } }
    low_level_cache(["key", 1]) { p { "cached" } }
  end
end

class CustomElement < Phlex::HTML
  register_element :my_widget, tag: "my-widget"
end

class Embedded < Phlex::HTML
  def view_template
    svg(viewBox: "0 0 10 10") do |s|
      s.path(d: "M0 0")
    end
    # @type var sym: Symbol
    sym = register_element_result
  end

  private def register_element_result
    CustomElement.register_element(:other)
  end
end

class Sparkline < Phlex::SVG
  def initialize(points:)
    @points = points
  end

  def view_template
    svg(width: 100, height: 20, stroke_width: 1) do
      linearGradient(id: "gradient", x1: "0", x2: "0", y1: "0", y2: "1") do
        stop(class: "start", offset: "0%", stop_opacity: "0.75")
      end
      polygon(points: @points, fill: "url(#gradient)")
      polyline(class: ["a", "b"], points: @points)
      g { circle(cx: 1, cy: 1, r: 1) }
      cdata "data"
      tag(:rect, width: 1)
    end
  end
end

# @type var svg_string: String
svg_string = Sparkline.call(points: "0,0 1,1")
svg_string = Sparkline.new(points: "0,0").call
# @type var svg_type: String
svg_type = Sparkline.new(points: "").content_type

module Components
  extend Phlex::Kit
end

# @type var from_block: String
from_block = Phlex.html { div { "inline" } }
from_block = Phlex.svg { circle(r: 1) }

begin
  Greeting.call(name: "x")
rescue Phlex::DoubleRenderError, Phlex::ArgumentError, Phlex::RuntimeError, Phlex::NameError => e
  # @type var error: Phlex::Error
  error = e
  error.class
end

Phlex::VERSION.upcase
Phlex::SGML::SafeObject.name
# @type var greeting_proc: ^(Phlex::SGML) -> nil
greeting_proc = Greeting.new(name: "a").to_proc
