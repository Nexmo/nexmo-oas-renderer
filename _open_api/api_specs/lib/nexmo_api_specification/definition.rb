module NexmoApiSpecification
  module Definition
    def self.load(definition)
      return false unless exists?(definition)
      File.read(path(definition))
    end

    def self.load!(definition)
      load(definition) || raise('Definition does not exist')
    end

    def self.path(definition)
      File.join NexmoApiSpecification.root, 'definitions', "#{definition}.yml"
    end

    def self.exists?(definition)
      File.exist? path(definition)
    end
  end
end
