require "devise_invitable"
require "active_record"
require "action_controller"

class User < ActiveRecord::Base
  devise :database_authenticatable, :invitable, invite_for: 2.weeks
end

class Admin < ActiveRecord::Base
  devise :invitable, invite_for: 0, validate_on_invite: true
end

Devise.invite_for = 2.weeks
Devise.invite_for = 0
Devise.validate_on_invite = true
Devise.invitation_limit = nil
Devise.invite_key = { email: /\A[^@]+@[^@]+\z/ }
Devise.resend_invitation = false
Devise.invited_by_class_name = "User"
Devise.invited_by_foreign_key = :inviter_id
Devise.invited_by_counter_cache = :invitations_count
Devise.allow_insecure_sign_in_after_accept = false
Devise.require_password_on_accepting = false

# @type var invite_for: (Integer | ActiveSupport::Duration)?
invite_for = Devise.invite_for
# @type var validate_on_invite: bool
validate_on_invite = Devise.validate_on_invite
# @type var limit: Integer?
limit = Devise.invitation_limit
# @type var invite_key: Hash[Symbol, untyped]
invite_key = Devise.invite_key
# @type var resend: bool
resend = Devise.resend_invitation
# @type var class_name: String?
class_name = Devise.invited_by_class_name
# @type var foreign_key: (Symbol | String)?
foreign_key = Devise.invited_by_foreign_key
# @type var counter_cache: (Symbol | String)?
counter_cache = Devise.invited_by_counter_cache
# @type var insecure: bool
insecure = Devise.allow_insecure_sign_in_after_accept
# @type var require_password: bool
require_password = Devise.require_password_on_accepting

class Invitation
  def run(inviter)
    # @type var user: User
    user = User.invite!({ email: "new_user@example.com", name: "John Doe" }, inviter)
    # @type var other: User
    other = User.invite!(email: "other@example.com", skip_invitation: true)
    # @type var yielded: User
    yielded = User.invite!(email: "yielded@example.com") do |u|
      u.skip_invitation = true
    end
    User.invite!({ email: "a@example.com" }, nil, { validate: false })
    User.invite_mail!({ email: "mail@example.com" }, inviter, {})

    # @type var accepted: User
    accepted = User.accept_invitation!(invitation_token: "token", password: "secret", password_confirmation: "secret")
    # @type var found: User?
    found = User.find_by_invitation_token("token", true)
    found&.valid_invitation?
    # @type var unsaved: User
    unsaved = User.find_by_invitation_token(nil, false)

    user.invite!
    user.invite!(inviter)
    user.invite!(inviter, { validate: false })
    user.invite! { |u| u.skip_invitation = true }
    user.deliver_invitation
    user.deliver_invitation({ locale: :ja })

    # @type var saved: bool?
    saved = user.accept_invitation!
    user.accept_invitation
    # @type var created_by_invite: bool
    created_by_invite = user.created_by_invite?
    # @type var invited: bool
    invited = user.invited_to_sign_up?
    # @type var accepting: bool
    accepting = user.accepting_invitation?
    # @type var accepted_flag: bool
    accepted_flag = user.invitation_accepted?
    # @type var accepted_or_not_invited: bool
    accepted_or_not_invited = user.accepted_or_not_invited?
    # @type var valid: bool
    valid = user.valid_invitation?
    # @type var user_limit: Integer?
    user_limit = user.invitation_limit
    user.invitation_limit = 5
    user.skip_invitation = true
    # @type var skip: bool?
    skip = user.skip_invitation
    # @type var raw: String?
    raw = user.raw_invitation_token
    # @type var encrypted: String?
    encrypted = user.encrypted_invitation_token
    # @type var due_at: ActiveSupport::TimeWithZone?
    due_at = user.invitation_due_at

    # @type var klass_invite_for: (Integer | ActiveSupport::Duration)?
    klass_invite_for = User.invite_for
    # @type var klass_validate: bool
    klass_validate = User.validate_on_invite
    # @type var klass_limit: Integer?
    klass_limit = User.invitation_limit
    # @type var klass_key: Hash[Symbol, untyped]
    klass_key = User.invite_key
    # @type var klass_resend: bool
    klass_resend = User.resend_invitation
    # @type var klass_name: String?
    klass_name = User.invited_by_class_name
    # @type var klass_fk: (Symbol | String)?
    klass_fk = User.invited_by_foreign_key
    # @type var klass_cache: (Symbol | String)?
    klass_cache = User.invited_by_counter_cache
    # @type var klass_insecure: bool
    klass_insecure = User.allow_insecure_sign_in_after_accept
    # @type var klass_require: bool
    klass_require = User.require_password_on_accepting
    # @type var fields: Array[Symbol]
    fields = User.invite_key_fields

    User.no_active_invitation.count
    User.created_by_invite.count
    User.invitation_not_accepted.count
    User.invitation_accepted.count

    User.after_invitation_accepted :notify
    User.before_invitation_created { |u| u }
    User.after_invitation_created :notify
    User.before_invitation_accepted :notify

    [other, yielded, accepted]
  end
end

class InvitationsController < Devise::InvitationsController
  def create
    super do |resource|
      resource
    end
  end

  def update
    raw_invitation_token = update_resource_params[:invitation_token]
    self.resource = accept_resource
    raw_invitation_token
  end

  def edit
    resource_from_invitation_token
    super
  end

  def new
    authenticate_inviter!
    super
  end

  def invite_resource
    super { |u| u }
  end

  def accept_resource
    resource_class.accept_invitation!(update_resource_params)
  end

  def invite_params
    super.merge("role" => "member")
  end

  def after_invite_path_for(inviter, invitee = nil)
    after_accept_path_for(inviter) + invalid_token_path_for(:user)
  end

  def destroy
    current_inviter
    super
  end
end
