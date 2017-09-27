module HashCleaner
  def self.clean(config)
    flat(config).reject do |key, element|
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

  def self.flat(c)
    c.each do |_, element|
      if element['type'] == 'collection' then
        element['value'].each do |v|
          v.keys.each do |key|
            v[key] = v[key]['value']
          end
        end
      end
    end
  end
end

