module Presenters
  class Markdown

    def initialize(document_name:)
      @document_name = document_name
    end

    def frontmatter
      @frontmatter ||= YAML.safe_load(document)
    end

    def document_title
      @document_title ||= frontmatter['meta_title'] || frontmatter['title']
    end

    def wip?
      !Sinatra::Application.settings.development? && frontmatter['wip']
    end

    def show_feedback?
      wip?
    end

    def redirect?
      frontmatter['redirect']
    end

    def content
      @content ||= MarkdownPipeline.new({
        code_language: nil,
        #current_user: current_user,
      }).call(@document)
    end

    def document_path
      @document_path ||= "_documentation/#{@document_name}.md"
    end

    def document
      @document ||= File.read("#{Sinatra::Application.root}/#{document_path}")
    end

  end
end
