require "dotenv"

# @type var loaded: Hash[String, String]
loaded = Dotenv.load
loaded = Dotenv.load(".env.default")
loaded = Dotenv.load(".env", overwrite: :warn)
loaded = Dotenv.overwrite(".env")
loaded = Dotenv.overload(".env")
loaded.each_key { |key| key.upcase }

# These raise Errno::ENOENT when the file does not exist, so they are not called
strict_loads = lambda do
  # @type var strict: Hash[String, String]
  strict = Dotenv.load!(".env")
  strict = Dotenv.load(".env", ".env.local", overwrite: true, ignore: false)
  strict = Dotenv.overwrite!(".env")
  strict = Dotenv.overload!(".env.production")
  strict = Dotenv.parse(".env", overwrite: true, ignore: false)
  strict
end

# @type var parsed: Hash[String, String]
parsed = Dotenv.parse(".env")
parsed = Dotenv.parse(".env.a", ".env.b") { |env| env.filename.empty? ? nil : env }
parsed = Dotenv.parse(".env", overwrite: :warn)
parsed.fetch("KEY", "")

# @type var from_string: Hash[String, String]
from_string = Dotenv::Parser.call("KEY=value\n")
from_string = Dotenv::Parser.call("KEY=value\n", overwrite: true)
from_string.fetch("KEY", "")

# @type var length: Integer
length = Dotenv.modify("FOO" => "bar", "BAZ" => nil) { ENV.fetch("FOO", "").length }

# Environment.new reads the file, which raises Errno::ENOENT when it is missing
read_environment = lambda do
  # @type var environment: Dotenv::Environment
  environment = Dotenv::Environment.new(".env", overwrite: true)
  # @type var overwrite_mode: bool | :warn
  overwrite_mode = environment.overwrite
  [environment.filename.upcase, overwrite_mode]
end

begin
  Dotenv.require_keys("DATABASE_URL", "SECRET_KEY_BASE")
  Dotenv.require_keys(["DATABASE_URL", "REDIS_URL"])
rescue Dotenv::MissingKeys => e
  e.message.upcase
rescue Dotenv::Error => e
  e.message.upcase
end

Dotenv::VERSION.upcase

# Dotenv::Rails is only defined after require "dotenv/rails", which needs Rails
rails_config = lambda do
  # @type var rails_loaded: Hash[String, String]
  rails_loaded = Dotenv::Rails.load
  rails_loaded = Dotenv::Railtie.load

  # @type var files: Array[String]
  files = Dotenv::Rails.files
  Dotenv::Rails.files = [".env.local", ".env"]
  # @type var overwrite: bool | :warn
  overwrite = Dotenv::Rails.overwrite
  Dotenv::Rails.overwrite = true
  Dotenv::Rails.overwrite = :warn
  # @type var autorestore: bool
  autorestore = Dotenv::Rails.autorestore
  Dotenv::Rails.autorestore = false
  [rails_loaded, files, overwrite, autorestore]
end
