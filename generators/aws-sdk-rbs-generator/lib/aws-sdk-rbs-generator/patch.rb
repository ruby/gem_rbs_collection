class String
  def underscore
    AwsSdkCodeGenerator::Underscore.underscore(self)
  end
end

class Symbol
  def underscore
    to_s.underscore
  end
end
