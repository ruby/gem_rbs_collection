require "asana"

client = Asana::Client.new do |c|
  c.authentication :access_token, "personal-access-token"
  c.default_headers "asana-enable" => "new_user_task_lists"
end

workspace = client.workspaces.find_all.first
workspace_gid = workspace&.gid || "1"
workspace&.name&.upcase

me = client.users.me
me.gid.length

project = client.projects.find_by_id("2", options: { fields: ["name", "due_date"] })
project.due_date&.length
client.projects.find_all(workspace: workspace_gid, archived: false).map(&:gid)

sections = client.sections.get_sections_for_project(project_gid: project.gid)
sections.each do |section|
  section.name&.strip
  client.tasks.get_tasks(section: section.gid, options: { fields: ["name", "completed"] }).each do |task|
    task.completed
  end
end

task = client.tasks.find_by_id("3")
task.name&.strip
task.assignee&.fetch("gid")
task.memberships&.each { |membership| membership["section"] }
task.custom_fields&.size
task.subtasks(per_page: 50).each { |subtask| subtask.gid }
task.dependencies.to_a.size
task.stories.each { |story| story.created_at }
task.tags.map(&:name)
task.projects(per_page: 10).first&.gid
task.dependents.size
task.start_at&.length
task.assignee_section&.gid
task.permalink_url.length
project.completed_by&.gid
project.tasks(per_page: 50, options: { fields: ["name"] }).first&.name
Asana::Resources::Task.find_by_tag(client, tag: "6").to_a
client.portfolios.find_by_id("5").custom_field_settings.map(&:is_important)
task.update(completed: true).completed
task.attach(filename: "notes.txt", mime: "text/plain", io: StringIO.new("hello")).name

new_task = Asana::Resources::Task.create(client, workspace: workspace_gid, name: "Write RBS")
client.tasks.update_task(task_gid: new_task.gid, name: "Write more RBS")
client.tasks.add_project_for_task(task_gid: new_task.gid, project: project.gid)
client.sections.add_task_for_section(section_gid: "4", task: new_task.gid)
client.tasks.get_subtasks_for_task(task_gid: new_task.gid).first&.gid
client.tasks.search_tasks_for_workspace(workspace_gid: workspace_gid, text: "RBS", completed: false).to_a

tags = client.tags.get_tags_for_workspace(workspace_gid: workspace_gid)
tags.select { |tag| tag.name == "urgent" }.each { |tag| tag.get_tasks_with_tag.size }

list = client.user_task_lists.get_user_task_list_for_user(user_gid: "me", workspace: workspace_gid)
client.tasks.find_all(user_task_list: list.gid, completed_since: "now").next_page

portfolio = client.portfolios.find_by_id("5")
client.portfolios.get_items_for_portfolio(portfolio_gid: portfolio.gid).map(&:name)

client.custom_fields.get_custom_fields_for_workspace(workspace_gid: workspace_gid).map(&:type)
client.attachments.find_by_task(task: new_task.gid).each { |attachment| attachment.view_url }
client.webhooks.get_all(workspace: workspace_gid).each { |webhook| webhook.active }

response = client.get("/users/me")
response.body["data"]

begin
  client.tasks.find_by_id("missing")
rescue Asana::Errors::NotFound => e
  e.response&.status
rescue Asana::Errors::RateLimitEnforced => e
  e.retry_after_seconds + 1
end
