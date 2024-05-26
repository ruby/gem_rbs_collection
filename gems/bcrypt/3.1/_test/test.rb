require "bcrypt"

raw_password = 'password123'

# BCrypt::Password
hashed_password = BCrypt::Password.create(raw_password, { cost: 4 })
BCrypt::Password.valid_hash?(hashed_password)
BCrypt::Password.valid_hash?(hashed_password.to_s)

BCrypt::Password.new(hashed_password)
BCrypt::Password.new(hashed_password.to_s)

hashed_password == raw_password
hashed_password == raw_password.to_s
hashed_password.is_password?(raw_password)

# BCrypt::Engine
BCrypt::Engine.cost = 5
BCrypt::Engine.cost < 10
salt = BCrypt::Engine.generate_salt(4)
BCrypt::Engine.hash_secret(raw_password, salt)
BCrypt::Engine.valid_salt?("invalid salt")
BCrypt::Engine.valid_secret?("password")
BCrypt::Engine.calibrate(100)
BCrypt::Engine.autodetect_cost(salt)

# BCrypt::Error
begin
  raise BCrypt::Errors::InvalidSalt
  raise BCrypt::Errors::InvalidHash
  raise BCrypt::Errors::InvalidCost
  raise BCrypt::Errors::InvalidSecret
rescue
end
