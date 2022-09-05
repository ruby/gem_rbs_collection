# RBS for enumerize gem

The directory that defines the RBS files for the [enumerize](https://github.com/brainspec/enumerize) gem.

## Usage

### enumerize method

The most common use cases for this gem would be:

```rb
# user.rb
require 'enumerize'

class User
  extend Enumerize

  enumerize :role, in: %i(user admin)
end
```

In this case, the RBS file should be written as follows:

```
# user.rbs
class User
  extend Enumerize
  extend Enumerize::Base::ClassMethods
end
```

Note that `Enumerize::Base::ClassMethods` is also necessary.

## Why do we need additional `extend` to RBS file?

Take the `enumerize` method as an example. Because this method is dynamically defined in the calling class.
[enumerize/base\.rb at d4438ecf8f90a24b8fb0e84b9d4338ae4a236352 · brainspec/enumerize](https://github.com/brainspec/enumerize/blob/d4438ecf8f90a24b8fb0e84b9d4338ae4a236352/lib/enumerize/base.rb#L6)

Therefore, simply writing `extend Enumerize` in the RBS file does not define the `enumerize` method.

Currently, RBS doesn't have any features to include/extend modules dynamically, so this problem can occur with other methods.
In such cases, check the source of the method definition and include/extend it in the RBS file.
