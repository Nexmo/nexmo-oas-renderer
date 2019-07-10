require 'forwardable'
require_relative './formats'
require_relative './groups'
require_relative './versions'
require_relative '../services/open_api_definition_resolver'

module Nexmo
  module OAS
    module Renderer
      module Presenters

        class OpenApiSpecification
          extend Forwardable

          attr_reader :definition_name

          def_delegators :@versions, :current_version, :available_versions
          def_delegators :@groups, :groups

          def initialize(definition_name:, expand_responses:)
            @definition_name  = definition_name
            @expand_responses = expand_responses
            @versions         = Versions.new(definition_name)
            @groups           = Groups.new(definition)
          end

          def errors?
            File.exist?("#{API.oas_path}/../errors/#{@definition_name}.md")
          end

          def definition_errors
            @definition_errors ||= MarkdownPipeline.new.call(
              File.read("#{API.oas_path}/../errors/#{@definition_name}.md")
            ) if errors?
          end

          def definition
            @definition ||= OpenApiDefinitionResolver.find(@definition_name)
          end

          def auto_expand_responses
            @expand_responses
          end

          def formats
            @formats ||= Formats.new(definition.endpoints.flat_map(&:responses)).extract
          end
        end
      end
    end
  end
end
