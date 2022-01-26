class ApplicationService
  def self.call(*args, &block)
    new(*args, &block).call
  end

  private

  def missing_attribute(attribute)
    raise NotImplementedError, I18n.t('lib.missing_attribute', attr: attribute)
  end
end
