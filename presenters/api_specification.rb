module Presenters
  class ApiSpecification

    def initialize(params:, code_language:)
      @params        = params
      @code_language = code_language
    end

    def document_name
      @document_name ||= begin
                           if @code_language == 'templates'
                             'verify/templates'
                           elsif @code_language == 'ncco'
                             'voice/ncco'
                           else
                             @params[:splat].first
                           end
                         end
    end

    def side_navigation
      "api/#{document_name}"
    end

    def document_path
      "_api/#{document_name}.md"
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
      @content ||= MarkdownPipeline.new({ code_language: code_language }).call(document)
    end

    def code_language
      return if !@code_language || @code_language == 'templates'
      # TODO: fix me
      #CodeLanguage.find(@code_language)
    end
  end
end
