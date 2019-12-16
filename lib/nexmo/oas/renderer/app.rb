require 'sinatra/base'
require 'active_support'
require 'active_support/core_ext/array/conversions'
require 'active_support/core_ext/string/output_safety'
require 'active_model'

require_relative'./decorators/response_parser_decorator'
require_relative'./pipelines/markdown_pipeline'
require_relative'./presenters/api_specification'
require_relative'./presenters/open_api_specification'
require_relative'./presenters/navigation'
require_relative'./presenters/response_tabs'
require_relative'./helpers/render'
require_relative'./helpers/navigation'
require_relative'./helpers/summary'
require_relative'./helpers/url'
require_relative './services/code_language_api'
require_relative'./lib/core_ext/string'

require 'dotenv/load'

module Nexmo
  module OAS
    module Renderer
      class API < Sinatra::Base

        Tilt.register Tilt::ERBTemplate, 'html.erb'

        if defined?(NexmoDeveloper::Application)
          view_paths = [views, NexmoDeveloper::Application.root.join("app", "views")]
          set :views, view_paths
        end

        set :mustermann_opts, { type: :rails }
        set :oas_path, (ENV['OAS_PATH'] || './')
        set :bind, '0.0.0.0'

        helpers do
          include Helpers::Render
          include Helpers::Navigation
          include Helpers::Summary
          include Helpers::URL
        end

        def parse_params(extension)
          extensions = extension.split('.')
          case extensions.size
          when 1
            { definition: extensions.first}
          when 2
            if extensions.second.match? /v\d+/
              { definition: extensions.first, version: extensions.second }
            else
              { definition: extensions.first, format: extensions.second }
            end
          when 3
            { definition: extensions.first, version: extensions.second, format: extensions.last }
          else
            {}
          end
        end

        def check_redirect!
          if defined?(NexmoDeveloper::Application)
            redirect_path = Redirector.find(request)
            redirect(redirect_path) if redirect_path
          end
        end

        def check_oas_constraints!(definition)
          if defined?(NexmoDeveloper::Application)
            pass unless OpenApiConstraint.match?(definition)
          end
        end

        error Errno::ENOENT do
          layout = defined?(NexmoDeveloper::Application) ? :'layouts/api.html' : false
          not_found erb :'static/404', layout: layout
        end

        error Exception do
          File.read("#{API.root}/public/500.html")
        end

        unless defined?(NexmoDeveloper::Application)
          get '/' do
            prefix = "#{API.oas_path}"
            @definitions = Dir.glob("#{prefix}/**/*.yml").map do |d|
              d.gsub("#{prefix}/", '').gsub('.yml', '')
            end.sort.reject { |d| d.include? 'common/' }
            erb :'api/index', layout: false
          end
        end

        def set_code_language
          return if params[:code_language] == 'templates'
          @code_language = params[:code_language]
        end

        before do
          set_code_language
        end

        get '(/api)/*definition' do
          check_redirect!

          parameters = parse_params(params[:definition])
          definition = [parameters[:definition], parameters[:version]].compact.join('.')
          check_oas_constraints!(definition)

          @specification = Presenters::OpenApiSpecification.new(
            definition_name: definition,
            expand_responses: params.fetch(:expandResponses, nil),
          )

          if ['yml', 'json'].include?(parameters[:format])
            send_file @specification.definition.path, disposition: :attachment
          else
            if defined?(NexmoDeveloper::Application)
              erb :'open_api/show', layout: :'layouts/page-full.html'
            else
              erb :'open_api/show', layout: :'layouts/open_api'
            end
          end
        end

        def set_document
          if params[:code_language] == 'templates'
            @document = 'verify/templates'
          elsif params[:code_language] == 'ncco'
            @document = 'voice/ncco'
          elsif CodeLanguage.exists?(params[:code_language])
            @document = params[:document]
          else
            @document = "#{params[:document]}/#{params[:code_language]}"
          end
        end

        get '(/api)/*document(/:code_language)' do
          set_document

          @specification = Presenters::ApiSpecification.new(
            document_name: @document,
            code_language: @code_language
          )

          @navigation = Presenters::Navigation.new(
            content: @specification.content,
            title: @specification.side_navigation_title,
          )

          if defined?(NexmoDeveloper::Application)
            @content = @navigation.content
            @side_navigation_title = @navigation.title

            erb :'api/show', layout: :'layouts/api.html'
          else
            erb :'api/show', layout: :'layouts/api'
          end
        end
      end
    end
  end
end
