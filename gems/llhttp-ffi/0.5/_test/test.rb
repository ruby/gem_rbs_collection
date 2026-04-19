require "llhttp"

class MyDelegate < LLHttp::Delegate
end

parser = LLHttp::Parser.new(MyDelegate.new, type: :response)
parser.reset
parser << "HTTP/1.1 200 OK\r\n\r\n"
parser.status_code
parser.http_major
parser.http_minor
