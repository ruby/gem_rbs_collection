# gem_rbs_collection: A collection of RBS for gems

**Naming note:** This repository was called `gem_rbs` before. We have renamed the repository to make it more clear that this is a collection of RBS files for gems.

[RBS](https://github.com/ruby/rbs) is a standard type signature syntax for Ruby programs.
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
This is different from when loading RBS files with library name that ignores directories starting with `_` (underscore).

## How to contribute

See [CONTRIBUTING.md](docs/CONTRIBUTING.md)
