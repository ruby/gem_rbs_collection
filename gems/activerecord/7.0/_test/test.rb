# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "activerecord"

module Test
  class ApplicationRecord < ActiveRecord::Base
    primary_abstract_class
  end

  class User < ApplicationRecord
    enum status: { active: 0, inactive: 1 }, _suffix: true
    enum :role, { admin: 0, user: 1 }, _prefix: true
    enum :classify, %w[hoge fuga], _default: "hoge"
    enum :hoge, fuga: 0, piyo: 1

    encrypts :secret, :key
    encrypts :token, deterministic: true
    encrypts :phrase, ignore_case: true
  end

  User.where.missing.to_sql
  User.deterministic_encrypted_attributes
  User.source_attribute_from_preserved_attribute(:phrase)
  user = User.new(secret: 'dummy', key: 'dummy', token: 'dummy', phrase: 'dummy')
  user.encrypt
  user.encrypted_attribute?(:secret)
  user.decrypt
  user.ciphertext_for(:token)
end
