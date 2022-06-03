require "active_decorator"

class User; end
user = User.new

ActiveDecorator::Decorator.instance
ActiveDecorator::Decorator.instance.decorate(user)

ActiveDecorator::ViewContext.current
