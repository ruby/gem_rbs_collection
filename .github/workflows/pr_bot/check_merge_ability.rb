require_relative "./utils"
require_relative "./merge_ability"

def comment_to_github(body, pr_number)
  sh! 'gh', 'pr', 'comment', pr_number, '--body', body, '--repo', GH_REPO
end

changed_gems = JSON.parse(ARGV[0])
changed_non_gems = JSON.parse(ARGV[1])
pr_number = ARGV[2]

ability = MergeAbility.new(changed_gems:, changed_non_gems:, pr_number:)

unless ability.can_merge_by?(ENV['COMMENTED_BY'], PR_AUTHOR)
  body = <<~BODY
    `/merge` command failed.

    You do not have permission to merge this PR.
    PR author, reviewers, and administrators can merge this PR.
  BODY
  comment_to_github(body, pr_number)
  exit 1
end

unless ability.approved?
  body  = <<~BODY
    `/merge` command failed.

    This PR is not approved yet by the reviewers. Please get approval from the reviewers.
    See the Actions tab for detail.
  BODY
  comment_to_github(body, pr_number)
  exit 1
end
