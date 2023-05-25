# gem_rbs_collection: A collection of RBS for gems

[RBS](https://github.com/ruby/rbs) is a standard type signature syntax for Ruby programs.
This is a community-managed collection of RBS files for gems that ship without RBS.

## Loading RBS from the repository

You can use `rbs collection` command to load RBS files from this repository.

```console
# Create rbs_collection.yaml
$ rbs collection init

# Resolve dependencies and install RBS files from this repository
$ rbs collection install
```

If `rbs_collection.yaml` exists, the installed RBSs are loaded automatically.
You do not need any configuration for `rbs` and `steep` commands.

See [collection.md](https://github.com/ruby/rbs/blob/master/docs/collection.md) in ruby/rbs repository for more details.

## How to contribute

See [CONTRIBUTING.md](docs/CONTRIBUTING.md)
