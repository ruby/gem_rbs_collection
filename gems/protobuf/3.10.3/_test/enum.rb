module Enum
  class States < ::Protobuf::Enum
    define :ALABAMA, 1
    define :CALIFORNIA, 2
    define :HOGE, 1
  end

  States::ALABAMA
  States::ALABAMA.to_i
  States::ALABAMA.tag
  States::ALABAMA.name

  States.fetch(1).___error___
  States.fetch(0)
  States.enums.___error___
  States.all_tags.___error___
end
