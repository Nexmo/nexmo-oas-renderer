require_relative './oas_parser'

module Nexmo
  module OAS
    module Renderer
      class OpenApiDefinitionResolver
        def self.find(name)
          path = paths(name).detect do |p|
            break p if File.file? p
          end

          return resolve(path) if path

          raise "Could not find definition '#{name}'"
        end

        def self.paths(name)
          ['json', 'yaml', 'yml'].map do |format|
            path(name, format)
          end
        end

        def self.path(name, format)
          "#{API.oas_path}/_open_api/api_specs/definitions/#{name}.#{format}"
        end

        def self.resolve(path)
          OasParser::Definition.resolve(path)
        end
      end
    end
  end
end
