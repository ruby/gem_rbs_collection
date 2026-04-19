# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "gitlab"

client = Gitlab.client(endpoint: "https://gitlab.example.com/api/v4", private_token: "private_token")

client.users(username: "username")

# get current user
client.user

# get specified user
client.user(1)

project_name = "gitlab-org/gitlab"

client.project(project_name)

client.branch(project_name, "main")

client.create_commit(
  project_name, "mr_source_branch", "commit message",
  [
    {
      action: "update",
      file_path: "test.txt",
      execute_filemode: false,
      content: "test",
    },
  ],
  start_branch: "main", author_email: "username@example.com", author_name: "username",
)

client.create_merge_request(
  project_name, "title",
  {
    source_branch: "mr_source_branch",
    target_branch: "main",
    remove_source_branch: true,
    description: "description",
  },
)

client.accept_merge_request(project_name, 1, auto_merge: true, should_remove_source_branch: true)
