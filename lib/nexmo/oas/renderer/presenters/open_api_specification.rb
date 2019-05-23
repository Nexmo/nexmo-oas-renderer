require 'forwardable'
require_relative './groups'
require_relative './versions'
require_relative '../services/open_api_definition_resolver'

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

    def display_initialization?
      initialization? && initialization_content && initialization_config
    end

    def initialization?
      File.file? "#{::NexmoOASRenderer::API.oas_path}/_open_api/initialization/#{@definition_name}.md"
    end

    def initialization_content
      @initialization_content ||= MarkdownPipeline.new.call(
                  File.read("#{::NexmoOASRenderer::API.oas_path}/_open_api/initialization/#{@definition_name}.md")
      ) if initialization?
    end

    def initialization_config
      @initialization_config ||= YAML.safe_load(
        File.read("#{::NexmoOASRenderer::API.oas_path}/_open_api/initialization/#{@definition_name}.md")
      ) if initialization?
    end

    def errors?
      File.file? "#{::NexmoOASRenderer::API.oas_path}/_open_api/errors/#{@definition_name}.md"
    end

    def definition_errors
      @definition_errors ||= MarkdownPipeline.new.call(
        File.read("#{::NexmoOASRenderer::API.oas_path}/_open_api/errors/#{@definition_name}.md")
      ) if errors?
    end

    def definition
      @definition ||= OpenApiDefinitionResolver.find(@definition_name)
    end

    def auto_expand_responses
      @expand_responses
    end
  end

end
