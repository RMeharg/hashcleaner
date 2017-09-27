module HashCleaner
  def self.clean(config)
    config.reject do |key, element|
      is_redacted_credential(element) ||
      is_not_configurable(element) ||
      is_required_and_not_set(element)
    end
  end

  private
  def self.is_redacted_credential(element)
    element['credential'] && element['value'].key('***')
  end

  def self.is_not_configurable(element)
    !element['configurable']
  end

  def self.is_required_and_not_set(element)
    !element['optional'] && element['value'].nil?
  end
end

