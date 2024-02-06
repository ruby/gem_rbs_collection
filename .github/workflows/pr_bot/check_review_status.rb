require_relative "./utils"
require "json"

def gem_accepted?(gem, approvers)
  reviewers = gem_reviewers(gem, BASE_SHA)

  # If reviewers is empty, it means that anyone cannot approve this PR.
  # So, we can merge this PR without approval.
  return true if reviewers.empty?

  # If the author is a reviewer, they can merge this PR themselves.
  return true if reviewers.include?(PR_AUTHOR)

  not (reviewers & approvers).empty?
end

def non_gem_accepted?(approvers)
  admins = administorators.map { _1['login'] }

  not (approvers & admins).empty?
end

def main(changed_gems, changed_non_gems, pr_number)
  approvers = approvements(HEAD_SHA, pr_number).map { _1['user']['login'] }

  status = 0

  # Check gem files
  not_approved_gems = changed_gems.reject { |gem| gem_accepted?(gem, approvers) }
  unless not_approved_gems.empty?
    puts "The following gems are not approved yet:"
    puts not_approved_gems.join("\n")
    status = 1
  end

  # Check non gem files
  if !changed_non_gems.empty? && !non_gem_accepted?(approvers)
    puts "The following files are changed, but not approved by the admin yet:"
    puts changed_non_gems.join("\n")
    status = 1
  end

  exit status
end

changed_gems = JSON.parse(ARGV[0])
changed_non_gems = JSON.parse(ARGV[1])
pr_number = ARGV[2]
main(changed_gems, changed_non_gems, pr_number)
