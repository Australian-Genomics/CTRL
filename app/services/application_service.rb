class ApplicationService
  def self.call(*args, &block)
    new(*args, &block).call
  end

  def missing_attribute(attribute)
    raise NotImplementedError, "Missing '#{attribute}' attribute"
  end
end
