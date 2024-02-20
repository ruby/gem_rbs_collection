require_relative "./merge_ability"

changed_gems = JSON.parse(ARGV[0])
changed_non_gems = JSON.parse(ARGV[1])
pr_number = ARGV[2]
file = ARGV[3]

ability = MergeAbility.new(changed_gems:, changed_non_gems:, pr_number:)

reviewer = ENV['REVIEWED_BY']

msg = "Thanks for your review, @#{reviewer}!\n\n"

if ability.approved?
  msg << <<~MSG
    @#{PR_AUTHOR}, @#{reviewer} This PR is ready to be merged.
    Just comment `/merge` to merge this PR.
  MSG
else
  unless ability.not_approved_gems.empty?
    msg << <<~MSG
      This PR still needs approval from the reviewers of the following gems.
      #{ability.not_approved_gems.map { "* `#{_1}`" }.join("\n")}
    MSG
  end
  if ability.waiting_admin_approval?
    msg << <<~MSG
      This PR still needs approval from the administrators.
    MSG
  end

  msg << "Please get approval from the reviewers."
end

File.write(file, msg)
