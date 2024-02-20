require 'securerandom'
require 'open3'
require 'yaml'
require "json"

BASE_SHA = ENV['BASE_SHA']
HEAD_SHA = ENV['HEAD_SHA']
PR_AUTHOR = ENV['PR_AUTHOR']
GH_REPO = ENV['GH_REPO']

def output(key, value)
  File.open(ENV['GITHUB_OUTPUT'], 'a') do |f|
    delimiter = SecureRandom.hex(20)
    f.puts "#{key}<<#{delimiter}"
    f.puts value
    f.puts delimiter
  end
  puts "Set #{key}=#{value}"
end

class CommandError < StandardError; end

def sh!(*cmd, **opt)
  Open3.capture3(*cmd, **opt).then do |out, err, status|
    raise CommandError, "Unexpected status #{status.exitstatus}\n\n#{err}" unless status.success?

    out
  end
end

def git(*cmd, **opt)
  sh! 'git', *cmd, **opt
end

def git?(*cmd, **opt)
  git(*cmd, **opt)
rescue CommandError
  nil
end

def gem_reviewers(gem, sha)
  begin
    yaml = git 'cat-file', '-p', "#{sha}:gems/#{gem}/_reviewers.yaml"
  rescue CommandError
    return []
  end

  content = YAML.safe_load(yaml)
  content['reviewers']
end

def log(msg)
  puts msg
end

def gh_api!(*args)
  resp = sh! 'gh', 'api',
    '-H', "Accept: application/vnd.github+json",
    '-H' 'X-GitHub-Api-Version: 2022-11-28', *args

  JSON.parse(resp)
end

def approvements(sha, pr_number)
  reviews = gh_api! "/repos/#{GH_REPO}/pulls/#{pr_number}/reviews"
  reviews.select do
    _1['commit_id'] == sha && (
      _1['state'] == 'APPROVED' ||
        (_1['body'].include?('APPROVE') && _1['state'] == 'COMMENTED')
    )
  end
end

def administorators
  users = gh_api! "/repos/#{GH_REPO}/collaborators"
  users.select { _1['permissions']['admin'] }
end
