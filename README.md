# gem_rbs_collection: A collection of RBS for gems

RBS is a standard type signature syntax for Ruby programs.
This is a community managed collection of RBS files for gems which ships without RBS.

## Loading RBS from the repository

`git submodule` is the easiest way to import this collection to your project.

```
# Add new submodule inside your project
$ git submodule add https://github.com/ruby/gem_rbs_collection.git vendor/rbs/gem_rbs_collection
```

### Using gem RBS from `rbs` command

Specify the path with `--repo` option and use `-r` option to require RBS of a library.

```
$ rbs --repo vendor/rbs/gem_rbs_collection/gems -r redis list
```

### Using gem RBS from Steep

Steep uses `Steepfile` to configure library RBSs to load.

```rb
target(:lib) do
  repo_path "vendor/rbs/gem_rbs_collection/gems"
  library "redis"
end
```

### Loading RBS directory from the repository directory

> This is not recommended, but I'm writing this section to load RBS files for other tools which doesn't support this feature yet.

You can load RBS files through directory path.

```
$ rbs -I vendor/rbs/gem_rbs_collection/gems/redis/4.2 list
```

If you load RBS files with directory path, it loads everything in the directory.
This is different from when loading RBS files with lbrary name that ignores directories starting with `_` (underscore).

## Adding RBS of a gem

[A doc](https://github.com/ruby/rbs/blob/master/docs/repo.md) is available for this feature.

Adding RBS files for a gem can be done with 4 steps.

1. Set up environment
2. Make a directory
3. Write RBS files
4. Write tests

(And you can open a pull request to get your code published.)

### Set up environment

Run `bin/setup`.
It runs `bundle install` with `--gemfile` option for the case the working copy is at under a directory for your application.

`bin/rbs` would also help to run the commands with correct `--gemfile` option.

### Make a directory

`mkdir -p gems/[gem]/[version]` works fine.

Specify the _major_ and _minor_ version you are using would be great for most cases.

```
$ mkdir -p gems/redis/4.2
```

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

#### Using RBS runtime testing

`rbs` gem provides a feature to insert runtime checks.
You can write a Ruby program and let the code run with runtime checks.

```
$ rbs --repo ../../.. -r redis test --target Redis _tests/test.rb
```

The drawback of runtime testing is that you need to set up dependencies -- servers, libraries, and data.

#### Using Steep

I have been testing with [Steep](https://github.com/soutaro/steep).

Add a `Steepfile` in `_test` directory and write test scripts.
Then you can run `steep test` to type check the test scripts.

See existing gems for examples, like [redis/4.2](https://github.com/ruby/gem_rbs_collection/tree/main/gems/redis/4.2/_test) or [listen/3.2](https://github.com/ruby/gem_rbs_collection/tree/main/gems/listen/3.2/_test).



