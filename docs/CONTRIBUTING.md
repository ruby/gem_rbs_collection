# Contribution Guide

## Adding RBS of a gem

Adding RBS files for a gem can be done with 4 steps.

1. Set up environment
2. Generate a boilerplate
3. Write RBS files
4. Write tests

(And you can open a pull request to get your code published.)

### Set up environment

Run `bin/setup`.
It runs `bundle install` with `--gemfile` option for the case the working copy is at under a directory for your application.

`bin/rbs` would also help to run the commands with correct `--gemfile` option.

### Generate a boilerplate

Execute `bin/init_new_gem GEM_NAME`.
This script generates an empty RBS to `gems/GEM_NAME/VERSION/GEM_NAME.rbs`, and makes `_test` directory to test the gem.

Specify the _major_ and _minor_ version you are using would be great for most cases.

We recommend adding `_scripts`, `_test`, and `_src` directories.
We assume `_scripts/test` script runs test of the gem, `_test` directory contains files for testing, and `_src` is a git submodule for the source code of the version of the gem.

### Write RBS files

You can write RBS files.

#### Focus on the most important part of the API

You may want to write everything of a gem.
We don't recommend doing it especially when you are starting.

Writing high-quality type definitions are difficult.

Focus on examples available through the `README` or docs of the gem.
Focus on the APIs your app is using.

#### Avoid adding top-level type aliases and interfaces

We don't recommend adding top-level type aliases and interfaces.

```
# Don't do this.

type redis_config = { host: String?, port: Integer? }

# Define the type inside ::Redis namespace

class Redis
  type config = { host: String?, port: Integer? }
end
```

#### Documents are optional

RBS supports writing docs of methods and classes.
If you want, you can copy the docs of the methods from Ruby code written in RDoc or YARD.

We don't require the docs.
It definitely helps, but keeping the docs up-to-date is not easy enough.

### Write tests

We recommend writing some tests to confirm your RBS works well with application code.
It is important that the testing is to confirm the relationship between RBS and application code, not the consistency with RBS and the implementation.

You can test your code with the following steps.

1. Write a Ruby program which uses the gem code
2. Confirm the consistency between the program and RBS

#### Using Steep

I have been testing with [Steep](https://github.com/soutaro/steep).

Add a `Steepfile` in `_test` directory and write test scripts.
Then you can run `steep check` to type check the test scripts.

See existing gems for examples, like [redis/4.2](https://github.com/ruby/gem_rbs_collection/tree/main/gems/redis/4.2/_test) or [listen/3.2](https://github.com/ruby/gem_rbs_collection/tree/main/gems/listen/3.2/_test).

### Write manifest.yaml

`manifest.yaml` describes dependencies which do not appear in the gemspec.
If this gem includes such dependencies, comment-out the following lines and declare the dependencies.
If all dependencies appear in the gemspec, you should remove this file.
See [the documentation](https://github.com/ruby/rbs/blob/master/docs/collection.md) for more information.

## Code Owners

Code owners are responsible for maintaining individual gems. They open and review PRs for the owned gems.

### What does code owner do

Code owners review and update RBS for the owned gems.

If a pull request is opened to the owned gem, the code owners are assigned as reviewers to the PR. Code owners review and merge (or reject) the PR.

Code owners can update the RBS themselves. Note that they cannot merge a PR themselves due to [GitHub's restriction](https://github.community/t/do-not-require-owner-approval-if-the-pull-request-is-from-an-owner/369), so feel free to ask the repository admin to merge the PR.

### Become a code owner

If you want to become a code owner, read this section.

Note that if you are the maintainer of the gem, you should consider moving RBS files to the gem's code repository and including them in the gem package instead.

#### If you want to become a code owner of existing gem

First, send PRs for the gem you want to maintain. We value your achievements.

Then, request us to you become a code owner in a PR or issue.

If it is accepted, open a PR to add your account into [.github/CODEOWNERS](https://github.com/ruby/gem_rbs_collection/blob/main/.github/CODEOWNERS).
We merge the PR and invite you as an outside collaborator to this repository.

#### If you want to become a code owner of new gem

If you want to become a code owner of new gem, which will be added by yourself, you can just add you to CODEOWNERS file.
The boilerplate generator asks you to become a code owner, so please enter your GitHub account if you'd like.
