Maintenance policy for RBS of Rails
===

We basically only accept changes for the versions listed under the **"List of currently supported releases"** in the [Rails' maintenance policy](https://rubyonrails.org/maintenance).
Or support the last version maintained in this repository.

Versions outside of that are generally not accepted for changes. We do not run tests for them, nor do we include them in format detection.

This is a measure to reduce maintenance costs.

If you have any questions, please contact the maintainers. Refer to `_reviewers.yaml` for the list of maintainers.

## Target gems

- actioncable
- actionmailer
- actionpack
- actiontext
- actionview
- activejob
- activemodel
- activerecord
- activestorage
- activesupport
- railties

## See also

https://github.com/ruby/gem_rbs_collection/issues/788
