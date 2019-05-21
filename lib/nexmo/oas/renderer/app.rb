require 'sinatra/base'
require 'active_support'
require 'active_support/core_ext/array/conversions'
require 'active_support/core_ext/string/output_safety'

require_relative'./decorators/response_parser_decorator'
require_relative'./pipelines/markdown_pipeline'
require_relative'./presenters/home'
require_relative'./presenters/api_specification'
require_relative'./presenters/open_api_specification'
require_relative'./presenters/navigation'
require_relative'./helpers/render'
require_relative'./helpers/navigation'
require_relative'./helpers/summary'
require_relative'./helpers/url'

require_relative'./lib/core_ext/string'

module NexmoOASRenderer
  class API < Sinatra::Base

    Tilt.register Tilt::ERBTemplate, 'html.erb'

    if defined?(NexmoDeveloper::Application)
      view_paths = [views, NexmoDeveloper::Application.root.join("app", "views")]
      set :views, view_paths
    end

    set :mustermann_opts, { type: :rails }

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

    get '(/api)/*definition' do
      parameters = parse_params(params[:definition])
      definition = [parameters[:definition], parameters[:version]].compact.join('.')
      pass if !Constraints::OpenApi.match?(definition)

      @presenter = Presenters::Home.new(
        title: 'Nexmo Developer',
        env: NexmoOASRenderer::API.environment,
      )
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
