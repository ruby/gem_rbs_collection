require "phlex"

class HTMLElements < Phlex::HTML
  def view_template
    a(id: "a") { "content" }
    abbr(id: "abbr") { "content" }
    address(id: "address") { "content" }
    article(id: "article") { "content" }
    aside(id: "aside") { "content" }
    audio(id: "audio") { "content" }
    b(id: "b") { "content" }
    bdi(id: "bdi") { "content" }
    bdo(id: "bdo") { "content" }
    blockquote(id: "blockquote") { "content" }
    body(id: "body") { "content" }
    button(id: "button") { "content" }
    canvas(id: "canvas") { "content" }
    caption(id: "caption") { "content" }
    cite(id: "cite") { "content" }
    code(id: "code") { "content" }
    colgroup(id: "colgroup") { "content" }
    data(id: "data") { "content" }
    datalist(id: "datalist") { "content" }
    dd(id: "dd") { "content" }
    del(id: "del") { "content" }
    details(id: "details") { "content" }
    dfn(id: "dfn") { "content" }
    dialog(id: "dialog") { "content" }
    div(id: "div") { "content" }
    dl(id: "dl") { "content" }
    dt(id: "dt") { "content" }
    em(id: "em") { "content" }
    fencedframe(id: "fencedframe") { "content" }
    fieldset(id: "fieldset") { "content" }
    figcaption(id: "figcaption") { "content" }
    figure(id: "figure") { "content" }
    footer(id: "footer") { "content" }
    form(id: "form") { "content" }
    h1(id: "h1") { "content" }
    h2(id: "h2") { "content" }
    h3(id: "h3") { "content" }
    h4(id: "h4") { "content" }
    h5(id: "h5") { "content" }
    h6(id: "h6") { "content" }
    head(id: "head") { "content" }
    header(id: "header") { "content" }
    hgroup(id: "hgroup") { "content" }
    html(id: "html") { "content" }
    i(id: "i") { "content" }
    iframe(id: "iframe") { "content" }
    ins(id: "ins") { "content" }
    kbd(id: "kbd") { "content" }
    label(id: "label") { "content" }
    legend(id: "legend") { "content" }
    li(id: "li") { "content" }
    main(id: "main") { "content" }
    map(id: "map") { "content" }
    mark(id: "mark") { "content" }
    menu(id: "menu") { "content" }
    meter(id: "meter") { "content" }
    nav(id: "nav") { "content" }
    noscript(id: "noscript") { "content" }
    object(id: "object") { "content" }
    ol(id: "ol") { "content" }
    optgroup(id: "optgroup") { "content" }
    option(id: "option") { "content" }
    output(id: "output") { "content" }
    p(id: "p") { "content" }
    picture(id: "picture") { "content" }
    pre(id: "pre") { "content" }
    progress(id: "progress") { "content" }
    q(id: "q") { "content" }
    rp(id: "rp") { "content" }
    rt(id: "rt") { "content" }
    ruby(id: "ruby") { "content" }
    s(id: "s") { "content" }
    samp(id: "samp") { "content" }
    script(id: "script") { "content" }
    search(id: "search") { "content" }
    section(id: "section") { "content" }
    select(id: "select") { "content" }
    selectedcontent(id: "selectedcontent") { "content" }
    slot(id: "slot") { "content" }
    small(id: "small") { "content" }
    span(id: "span") { "content" }
    strong(id: "strong") { "content" }
    style(id: "style") { "content" }
    sub(id: "sub") { "content" }
    summary(id: "summary") { "content" }
    sup(id: "sup") { "content" }
    table(id: "table") { "content" }
    tbody(id: "tbody") { "content" }
    td(id: "td") { "content" }
    template(id: "template") { "content" }
    textarea(id: "textarea") { "content" }
    tfoot(id: "tfoot") { "content" }
    th(id: "th") { "content" }
    thead(id: "thead") { "content" }
    time(id: "time") { "content" }
    title(id: "title") { "content" }
    tr(id: "tr") { "content" }
    u(id: "u") { "content" }
    ul(id: "ul") { "content" }
    var(id: "var") { "content" }
    video(id: "video") { "content" }
    wbr(id: "wbr") { "content" }
    svg(width: 1) { |s| s.circle(r: 1) }
    area(id: "area")
    base(id: "base")
    br(id: "br")
    col(id: "col")
    embed(id: "embed")
    hr(id: "hr")
    img(id: "img")
    input(id: "input")
    link(id: "link")
    meta(id: "meta")
    source(id: "source")
    track(id: "track")
  end
end

class SVGElements < Phlex::SVG
  def view_template
    a(id: "a") { "content" }
    animate(id: "animate") { "content" }
    animateMotion(id: "animateMotion") { "content" }
    animateTransform(id: "animateTransform") { "content" }
    circle(id: "circle") { "content" }
    clipPath(id: "clipPath") { "content" }
    defs(id: "defs") { "content" }
    desc(id: "desc") { "content" }
    discard(id: "discard") { "content" }
    ellipse(id: "ellipse") { "content" }
    feBlend(id: "feBlend") { "content" }
    feColorMatrix(id: "feColorMatrix") { "content" }
    feComponentTransfer(id: "feComponentTransfer") { "content" }
    feComposite(id: "feComposite") { "content" }
    feConvolveMatrix(id: "feConvolveMatrix") { "content" }
    feDiffuseLighting(id: "feDiffuseLighting") { "content" }
    feDisplacementMap(id: "feDisplacementMap") { "content" }
    feDistantLight(id: "feDistantLight") { "content" }
    feDropShadow(id: "feDropShadow") { "content" }
    feFlood(id: "feFlood") { "content" }
    feFuncA(id: "feFuncA") { "content" }
    feFuncB(id: "feFuncB") { "content" }
    feFuncG(id: "feFuncG") { "content" }
    feFuncR(id: "feFuncR") { "content" }
    feGaussianBlur(id: "feGaussianBlur") { "content" }
    feImage(id: "feImage") { "content" }
    feMerge(id: "feMerge") { "content" }
    feMergeNode(id: "feMergeNode") { "content" }
    feMorphology(id: "feMorphology") { "content" }
    feOffset(id: "feOffset") { "content" }
    fePointLight(id: "fePointLight") { "content" }
    feSpecularLighting(id: "feSpecularLighting") { "content" }
    feSpotLight(id: "feSpotLight") { "content" }
    feTile(id: "feTile") { "content" }
    feTurbulence(id: "feTurbulence") { "content" }
    filter(id: "filter") { "content" }
    foreignObject(id: "foreignObject") { "content" }
    g(id: "g") { "content" }
    image(id: "image") { "content" }
    line(id: "line") { "content" }
    linearGradient(id: "linearGradient") { "content" }
    marker(id: "marker") { "content" }
    mask(id: "mask") { "content" }
    metadata(id: "metadata") { "content" }
    mpath(id: "mpath") { "content" }
    path(id: "path") { "content" }
    pattern(id: "pattern") { "content" }
    polygon(id: "polygon") { "content" }
    polyline(id: "polyline") { "content" }
    radialGradient(id: "radialGradient") { "content" }
    rect(id: "rect") { "content" }
    script(id: "script") { "content" }
    set(id: "set") { "content" }
    stop(id: "stop") { "content" }
    style(id: "style") { "content" }
    svg(id: "svg") { "content" }
    switch(id: "switch") { "content" }
    symbol(id: "symbol") { "content" }
    text(id: "text") { "content" }
    textPath(id: "textPath") { "content" }
    title(id: "title") { "content" }
    tspan(id: "tspan") { "content" }
    use(id: "use") { "content" }
    view(id: "view") { "content" }
    # @type var filename: String?
    filename = self.filename
  end
end
