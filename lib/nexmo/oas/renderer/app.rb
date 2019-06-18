require 'sinatra/base'
require 'active_support'
require 'active_support/core_ext/array/conversions'
require 'active_support/core_ext/string/output_safety'
require 'active_model'

require_relative'./constraints/redirector'
require_relative'./decorators/response_parser_decorator'
require_relative'./pipelines/markdown_pipeline'
require_relative'./presenters/api_specification'
require_relative'./presenters/open_api_specification'
require_relative'./presenters/navigation'
require_relative'./helpers/render'
require_relative'./helpers/navigation'
require_relative'./helpers/summary'
require_relative'./helpers/url'

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
        set :show_exceptions, :after_handler
        set :oas_path, (ENV['OAS_PATH'] || '.')

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
          redirect_path = Constraints::Redirector.find(request)
          redirect(redirect_path) if redirect_path
        end

        error Errno::ENOENT do
          layout = defined?(NexmoDeveloper::Application) ? :'layouts/api.html' : false
          not_found erb :'static/404', layout: layout
        end

        get '(/api)/*definition' do
          check_redirect!

          parameters = parse_params(params[:definition])
          definition = [parameters[:definition], parameters[:version]].compact.join('.')
          pass if !Constraints::OpenApi.match?(definition)

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

        get '(/api)/*document' do
          @specification = Presenters::ApiSpecification.new(document_name: params[:document])

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
