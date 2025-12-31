# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require 'audited'

class Post < ActiveRecord::Base
  extend Audited::Auditor::ClassMethods
  extend Audited::Auditor::AuditedClassMethods
  include Audited::Auditor::AuditedInstanceMethods

  belongs_to :user

  audited only: :title, associated_with: :user, max_audits: 10, comment_required: false
end

class Comment < ActiveRecord::Base
  extend Audited::Auditor::ClassMethods
  extend Audited::Auditor::AuditedClassMethods
  include Audited::Auditor::AuditedInstanceMethods

  audited
end

class User < ActiveRecord::Base
  extend Audited::Auditor::ClassMethods
  extend Audited::Auditor::AuditedClassMethods
  include Audited::Auditor::AuditedInstanceMethods

  audited only: [:name, :address], redacted: :email, redaction_value: '[FILTERED]', update_with_comment_only: false, except: :password, on: [:update, :destroy], if: :admin?

  has_associated_audits
end

Audited.ignored_default_callbacks = [:create, :update]
Audited.max_audits = 10
Audited.current_user_method = :authenticated_user
Audited.store_synthesized_enums = true
Audited.config do |config|
  config.audit_class = 'CustomAudit'
end

Audited.store[:audited_user] = 'username'
Audited.store[:audited_user] = User.new

Post.audited_columns
Post.non_audited_columns
Post.non_audited_columns = %w[content]
Post.without_auditing do
  Post.create!(title: 'Post without auditing')
end
Post.with_auditing do
  Post.create!(title: 'Post with auditing')
end
Post.disable_auditing if Post.auditing_enabled
Post.enable_auditing
Post.audit_as(User.new) do
  Post.create!(title: 'Post audited as user')
end
Post.auditing_enabled = true
Post.default_ignored_attributes

post = Post.new
post.revisions
post.revision(1)
post.revision_at(Date.parse('2016-01-01'))
