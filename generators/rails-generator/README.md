# rails-generator

This is a generating script for rails gems.

Dynamic method creation, dynamic inheritance, and method delegation in rails are complex.

We aim to automate as much as possible the parts that can be automated, and only write the parts where we want to specify the type.

## Development

### Install

```
$ bundle install
$ bundle exec rbs collection install
```

### Add RBS definition

Update `/known_sig` files.

The directories are separated by gem and by version, and the generator will automatically select the necessary files.

Note that if multiple version directories exist, only one will be selected.

### Add version

Update `Rakefile` and `/gemfiles`.

### Add gem

Update `Rakefile` and `/tasks`.

## Rake tasks

The default task will regenerate all code.

```
$ bundle exec rake
```

All subtasks are separated by version.

```
$ bundle exec rake 6.0:all
$ bundle exec rake 6.1:generate
```

Please see `$ bundle exec rake -T` also.

### Generate task

```
$ bundle exec rake 7.0:generate
```

Generate RBS file to `out` dir.

Rails gems has dependencies, so it loads all library code and outputs an RBS file.

### Install task

```
$ bundle exec rake 7.0:active_storage:install
```

Copy files from `out` to `/gems/*`.

## patch.rbs

Several libraries define `patch.rbs`.
The signatures here are temporary and should be written as library definitions to rbs and gem_rbs_collection.
As soon as the correct definitions are added, please remove the patch side.
