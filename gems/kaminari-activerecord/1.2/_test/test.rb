require "kaminari-activerecord"

class User < ActiveRecord::Base
end


User.page(1).per(10)
User.where(name: "John").page(1).per(10)
