#!/usr/bin/env ruby

require 'pathname'
require 'rbs'
require 'yaml'

def green(str)
  "\e[32m#{str}\e[0m"
end

def stdlib?(name)
  (RBS::Repository::DEFAULT_STDLIB_ROOT / name / '0').exist?
end

manifest_file = Pathname.pwd.basename.to_s == "_test" ?
  Pathname('../manifest.yaml') :
  Pathname('manifest.yaml')

if manifest_file.exist?
  manifest = YAML.safe_load(manifest_file.read)

  unless manifest && manifest.key?('dependencies') && !manifest['dependencies'].empty?
    puts <<~END
      #{manifest_file} exists but does not contain dependencies.
      Please add dependencies to #{manifest_file} or remove it.
    END
    exit 1
  end

  manifest['dependencies'].each do |dep|
    unless dep.key?('name')
      puts "#{dep} does not contain the name of dependency."
      exit 1
    end

    unless stdlib?(dep['name'])
      puts "#{dep['name']} is not a standard library."
      exit 1
    end
  end

  puts green "manifest.yaml is valid. 🐾"
else
  puts green "manifest.yaml is not exist skipped. 🐾"
end
