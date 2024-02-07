# Contribution Guide

## Before you start💎

**If you are the owner of the gem:**
Adding RBS files directory in your gem would be a better option.
Write RBS files, put them in `sig` directory, and included the directory in the gem package.

**If you are not the owner of the gem:**
Please refer to the following steps to contribute to this project.

## Adding RBS of a gem

Adding RBS files for a gem can be done with 4 steps.

1. Set up environment
2. Generate a boilerplate
3. Write RBS files
4. Write tests

(And you can open a pull request to get your code published.)

### Set up environment

Run `bin/setup`.
It runs `bundle install` with `--gemfile` option for the case the working copy is under a directory for your application.

`bin/rbs` would also help to run the commands with correct `--gemfile` option.

### Generate a boilerplate

Execute `bin/init_new_gem GEM_NAME`.
This script generates an empty RBS to `gems/GEM_NAME/VERSION/GEM_NAME.rbs`, and makes `_test` directory to test the gem.

Specify the _major_ and _minor_ version you are using would be great for most cases.

We recommend adding `_test` and `_src` directories.
We assume `_test` directory contains files for testing, and `_src` is a git submodule for the source code of the version of the gem.

### Write RBS files

You can write RBS files.

#### Focus on the most important part of the API

You may want to write everything of a gem.
We don't recommend doing it especially when you are starting.

Writing high-quality type definitions is difficult.

Focus on examples available through the `README` or docs of the gem.
Focus on the APIs your app is using.

#### Avoid adding top-level type aliases and interfaces

We don't recommend adding top-level type aliases and interfaces.

```rbs
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

1. Write a Ruby program which uses the gem code.
2. Execute `bin/test gems/GEM_NAME/VERSION` to run the test suites, including `rbs validate` and `steep check`.

See existing gems for examples, like [redis/4.2](https://github.com/ruby/gem_rbs_collection/tree/main/gems/redis/4.2/_test) or [listen/3.2](https://github.com/ruby/gem_rbs_collection/tree/main/gems/listen/3.2/_test).

### Write manifest.yaml

`manifest.yaml` describes dependencies which do not appear in the gemspec.
If this gem includes such dependencies, comment-out the following lines and declare the dependencies.
If all dependencies appear in the gemspec, you should remove this file.
See [the documentation](https://github.com/ruby/rbs/blob/master/docs/collection.md) for more information.

## Gem Reviewer

Gem Reviewers are responsible for maintaining individual gems. They open and review PRs for the owned gems.

### What does Gem Reviewer do

Gem Reviewers review and update RBS for the owned gems.

If a pull request is opened to the owned gem, the Bot requests the Gem Reviewers to review the PR. The Gem Reviewers review the PR and merge it if it is appropriate.
The Bot describes the review process as a comment on the PR.

Gem Reviewers also can open PRs to update RBS for the owned gems themselves.

### Become a Gem Reviewer

Add your GitHub account to the `gems/GEM_NAME/_reviewers.yaml`. For example:

```yaml
# gems/ast/_reviewers.yaml
reviewers:
  - pocke
```

Then open a pull request containing the change.

Note that if you are the maintainer of the gem, you should consider moving RBS files to the gem's code repository and including them in the gem package instead.

#### If you want to become a Gem Reviewer of existing gem

If you are the first Gem Reviewer of the gem, you can merge the PR by yourself. Otherwise, the pull request should be reviewed by the existing Gem Reviewers.

#### If you want to become a code owner of new gem

Enter your GitHub account to the `bin/init_new_gem` script. The script automatically fills the `_reviewers.yaml` file.
