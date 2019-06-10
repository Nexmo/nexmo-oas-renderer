require 'banzai'

Dir[File.join(__dir__, '../filters', '*.rb')].each { |f| require_relative f }

module Nexmo
  module OAS
    module Renderer
      class MarkdownPipeline < Banzai::Pipeline
        def initialize(options = {})
          super(
            # As Markdown
            Filters::Frontmatter,
            Filters::PHPInliner,
            Filters::InlineEscape,
            Filters::BlockEscape,
            Filters::Screenshot,
            Filters::Anchor,
            Filters::Audio,
            Filters::DynamicContent,
            Filters::Tooltip,
            Filters::Collapsible,
            Filters::Tab.new(options),
            Filters::CodeSnippets.new(options),
            Filters::CodeSnippet.new(options),
            Filters::Code,
            Filters::Indent,
            Filters::Modal,
            Filters::JsSequenceDiagram,
            Filters::Partial.new(options),
            Filters::Techio,
            Filters::Tutorials,
            Filters::CodeSnippetList,
            Filters::ConceptList,
            Filters::Language,
            Filters::Columns,
            Filters::Markdown.new(options),

            # As HTML
            Filters::UserPersonalization.new(options),
            Filters::Heading,
            Filters::Label.new(options),
            Filters::Break,
            Filters::Unfreeze,
            Filters::Icon,
            Filters::ExternalLink,
            Filters::TutorialLink
          )
        end
      end
    end
  end
end
