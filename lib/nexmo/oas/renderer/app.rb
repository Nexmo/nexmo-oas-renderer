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

    get '(/api)/*definition(/:code_language)' do
      pass if !Constraints::OpenApi.match?(params[:definition], params[:code_language])

      @presenter = Presenters::Home.new(
        title: 'Nexmo Developer',
        env: NexmoOASRenderer::API.environment,
      )
      @specification = Presenters::OpenApiSpecification.new(
        definition_name: params.fetch(:definition, nil),
        expand_responses: params.fetch(:expandResponses, nil),
      )


      if defined?(NexmoDeveloper::Application)
        erb :'open_api/show', layout: :'layouts/page-full.html'
      else
        erb :'open_api/show', layout: :'layouts/open_api'
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
