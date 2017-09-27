module HashCleaner
  def self.clean(config)
    config.reject do |key, element|
      (element['credential'] && element['value'].key('***')) || !element["configurable"]
    end
  end
end

