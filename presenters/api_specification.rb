module Presenters
  class ApiSpecification

    def initialize(document_name:)
      @document_name = document_name
    end

    def side_navigation
      "api/#{@document_name}"
    end

    def document_path
      "_api/#{@document_name}.md"
    end

    def document
      @document ||= File.read("#{::Sinatra::Application.root}/#{document_path}")
    end

    def frontmatter
      @frontmatter ||= YAML.safe_load(document)
    end

    def side_navigation_title
      @side_navigation_title ||= frontmatter.fetch('api')
    end

    def document_title
      @document_title ||= "#{side_navigation_title} > #{frontmatter.fetch('title')}"
    end

    def content
      @content ||= MarkdownPipeline.new.call(document)
    end
  end
end
