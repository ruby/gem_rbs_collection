# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "octokit"

# Provide authentication credentials
client = Octokit::Client.new(:access_token => 'personal_access_token')

# You can still use the username/password syntax by replacing the password value with your PAT.
# client = Octokit::Client.new(:login => 'defunkt', :password => 'personal_access_token')

# Fetch the current user
client.user

repo_name = "ruby/gem_rbs_collection"

client.repository(repo_name)
client.branch(repo_name, "main")

client.ref(repo_name, "heads/main")
client.create_ref(repo_name, "heads/pr_source_branch", "1234567")
client.commit(repo_name, "1234567")

file_body_sha = client.create_blob(repo_name, "aaa")

client.create_tree(repo_name,
                   [{ path: "test.txt", mode: "100644", type: "blob", sha: file_body_sha }],
                   base_tree: "1234567",
)

client.create_commit(
  repo_name,
  "commit message",
  "1234567",
  "1234567",
  author: {
    name: "user",
    email: "user@example.com",
  },
)

client.update_ref(repo_name, "heads/pr_source_branch", "1234567")

client.create_pull_request(repo_name, "main", "pr_source_branch", "title", "body", draft: true)

client.add_labels_to_an_issue(repo_name, 1, %w(bug))

client.add_assignees(repo_name, 1, %w(user))

client.request_pull_request_review(repo_name, 1, reviewers: %w(user))
