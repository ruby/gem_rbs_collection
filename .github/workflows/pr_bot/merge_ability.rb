require_relative "./utils"

class MergeAbility
  attr_reader :changed_gems, :changed_non_gems, :pr_number

  def initialize(changed_gems:, changed_non_gems:, pr_number:)
    @changed_gems = changed_gems
    @changed_non_gems = changed_non_gems
    @pr_number = pr_number
  end

  def approved?(pr_author)
    # Check non gem files
    if admin_review_required?
      log "This PR contains non-gem files. Admin approval is required. /merge does not work if the PR contains non-gem files."
      return false
    end

    # Check gem files
    unless is_approved = not_approved_gems.empty?
      log "The following gems are not approved yet:"
      log not_approved_gems.join("\n")
    end
    return is_approved
  end

  def can_merge_by?(commented_by, author)
    return true if commented_by == author
    return true if administorators.include?(commented_by)
    return true if all_gem_reviewers.include?(commented_by)
    return false
  end

  def not_approved_gems
    @not_approved_gems ||= changed_gems.reject { |gem| gem_accepted?(gem) }
  end

  def admin_review_required?
    not changed_non_gems.empty?
  end

  private

  def all_gem_reviewers
    @all_gem_reviewers ||= changed_gems.flat_map { |gem| gem_reviewers(gem, BASE_SHA) }
  end

  def gem_accepted?(gem)
    reviewers = gem_reviewers(gem, BASE_SHA)

    # If reviewers is empty, it means that anyone cannot approve this PR.
    # So, we can merge this PR without approval.
    return true if reviewers.empty?

    # If the author is a reviewer, they can merge this PR themselves.
    return true if reviewers.include?(PR_AUTHOR)

    not (reviewers & approvers).empty?
  end

  def approvers
    @approvers ||= approvements(HEAD_SHA, pr_number).map { _1['user']['login'] }
  end
end
