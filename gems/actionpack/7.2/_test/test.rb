class FooController < ActionController::Base
  allow_browser versions: :modern
end

class BarController < ActionController::Base
  allow_browser versions: { safari: 17.5, chrome: 127, ie: false }, block: -> { head :not_acceptable }
end
