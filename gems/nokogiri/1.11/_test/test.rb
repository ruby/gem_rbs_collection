# https://nokogiri.org/#how-to-use-nokogiri

require 'nokogiri'

# Fetch and parse HTML document
doc = Nokogiri::HTML(<<~HTML)
<body>
  <nav>
    <ul class="menu">
      <li><a href="#">hello</a></li>
    </ul>
  </nav>

  <article>
    <h2>hello</h2>
  </article>
</body>
HTML

# Search for nodes by css
doc.css('nav ul.menu li a', 'article h2').each do |link|
  puts link.content
end

# Search for nodes by xpath
doc.xpath('//nav//ul//li/a', '//article//h2').each do |link|
  puts link.content
end

# Or mix and match
doc.search('nav ul.menu li a', '//article//h2').each do |link|
  puts link.content
end
