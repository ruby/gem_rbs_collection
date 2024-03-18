require_relative "./utils"

paths = `git diff --name-only -z #{BASE_SHA}...#{HEAD_SHA}`.split("\0")
changed_gems = paths.select { _1.start_with?("gems/") }.map { _1.split("/")[1] }.uniq
changed_non_gems = paths.reject { _1.start_with?("gems/") }

output :gems, JSON.generate(changed_gems)
output :non_gems, JSON.generate(changed_non_gems)
