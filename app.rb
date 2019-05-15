require 'sinatra'
require 'active_support'
require 'active_support/core_ext/array/conversions'

require './decorators/response_parser_decorator'
require './pipelines/markdown_pipeline'
require './presenters/home'
require './presenters/api_specification'
require './presenters/open_api_specification'
require './presenters/navigation'

require './lib/core_ext/string'

set :mustermann_opts, { type: :rails }

helpers do
  def normalize_summary_title(summary, operation_id)
    # return summary early if provided
    return summary unless summary.nil?

    # If the operation ID is camelCase,
    if operation_id.match?(/^[a-zA-Z]\w+(?:[A-Z]\w+){1,}/x)
      # Use the rails `.underscore` method to convert someString to some_string
      operation_id = operation_id.underscore
    end

    # Replace snake_case and kebab-case with spaces and titelize the string
    operation_id = operation_id.gsub(/(_|-)/, ' ').titleize

    # Some terms need to be capitalised all the time
    uppercase_array = ['SMS', 'DTMF']
    operation_id.split(' ').map do |c|
      next c.upcase if uppercase_array.include?(c.upcase)
      c
    end.join(' ')
  end

  def parameter_values(enum)
    enum.map { |value| "<code>#{value}</code>" }.to_sentence(last_word_connector: ' or ', two_words_connector: ' or ')
  end
end

get '/api/*definition(/:code_language)' do
  pass if !OpenApiConstraint.match?(params[:definition], params[:code_language])

  @presenter = Presenters::Home.new(
    title: 'Nexmo Developer',
    env: Sinatra::Application.environment,
  )
  @specification = Presenters::OpenApiSpecification.new(
    definition_name: params.fetch(:definition, nil),
    expand_responses: params.fetch(:expandResponses, nil),
  )

  erb :'open_api/show', layout: :'layouts/open_api'
end

get '/api/*document' do
  @specification = Presenters::ApiSpecification.new(document_name: params[:document])

  @navigation = Presenters::Navigation.new(
    content: @specification.content,
    title: @specification.side_navigation_title,
  )

  erb :'api/show', layout: :'layouts/api'
end
