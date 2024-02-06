require_relative "./utils"

def can_merge?(commented_by, author, gem_reviewers)
  return true if commented_by == author
  return true if administorators.include?(commented_by)
  return true if gem_reviewers.include?(commented_by)
  return false
end

def all_gem_reviewers(changed_gems)
  changed_gems.flat_map { |gem| gem_reviewers(gem, BASE_SHA) }
end

reviewers = all_gem_reviewers(JSON.parse(ARGV[0]))
return if can_merge?(ENV['COMMENTED_BY'], PR_AUTHOR, reviewers)

raise "You do not have permission to merge this PR."
