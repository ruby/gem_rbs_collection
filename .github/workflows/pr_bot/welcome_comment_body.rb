require_relative "./utils"

ADMINS = %w[@pocke]

changed_gems = JSON.parse(ARGV[0])
changed_non_gems = JSON.parse(ARGV[1])

msgs = [<<~MSG]
  @#{PR_AUTHOR} Thanks for your contribution!

  Please follow the instructions below for each change.
  See also: https://github.com/ruby/gem_rbs_collection/blob/main/docs/CONTRIBUTING.md

  ## Available commands

  You can use the following commands by commenting on this PR.

  * `/merge`: Merge this PR if CI passes
MSG

changed_gems.each do |gem|
  exist_in_base = git? 'cat-file', '-e', "#{BASE_SHA}:gems/#{gem}"
  exist_in_head = git? 'cat-file', '-e', "#{HEAD_SHA}:gems/#{gem}"

  msg = "## `#{gem}`\n\n"

  case
  when !exist_in_base # new gem
    msg << <<~MSG
      This RBS files are newly added.

      You can merge this PR immediately if the CI passes.
      Just comment `/merge` to merge this PR.
    MSG
  when exist_in_head  # updated gem
    reviewers = gem_reviewers(gem, BASE_SHA)
    # TODO: if reviewers do not respond
    msg << <<~MSG
      You changed RBS files for an existing gem.
    MSG

    if reviewers.empty?
      msg << <<~MSG
        This gem does not have reviewers. So you can merge this PR immediately if the CI passes.
        We recommend you add yourself to the reviewers for this gem.
      MSG
    elsif reviewers.include?(PR_AUTHOR)
      msg << <<~MSG
        You can merge this PR yourself because you are a reviewer of this gem.
        Just comment `/merge` to merge this PR.

        You can also request a review from other reviewers if you want.
      MSG
    else
      msg << <<~MSG
        You need to get approval from the reviewers of this gem.

        #{reviewers.map { "@#{_1}" }.join(', ')}, please review and approve the changes.
        After that, the PR author or the reviewers can merge this PR.
        Just comment `/merge` to merge this PR.
      MSG
    end
  when !exist_in_head # removed gem
    reviewers = gem_reviewers(gem, BASE_SHA)

    msg << <<~MSG
      You removed RBS files for this gem.
    MSG

    if reviewers.empty?
      msg << <<~MSG
        You can merge this PR immediately if the CI passes.
        Just comment `/merge` to merge this PR.
      MSG
    else
      msg << <<~MSG
        You need to get approval from the reviewers of this gem.

        #{reviewers.map { "@#{_1}" }.join(', ')}, please review and approve the changes.
        After that, the PR author or the reviewers can merge this PR.
        Just comment `/merge` to merge this PR.
      MSG
    end
  else
    raise "unreachable"
  end

  msgs << msg
end

unless changed_non_gems.empty?
  msgs << <<~MSG
    You changed non-gem files.

    #{ADMINS.join(', ')}, please review and approve the changes.
  MSG
end

body = msgs.join("\n\n-----\n\n")

output :welcome_comment_body, body
