require 'sinatra'
require 'active_support'
require 'active_support/core_ext/array/conversions'

require './decorators/response_parser_decorator'
require './pipelines/markdown_pipeline'
require './presenters/home'
require './presenters/specification'

require './lib/core_ext/string'

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

get '/api/*/?' do
  # TODO: handle code_languages
  definition = params[:splat].first
  pass unless OpenApiConstraint.products_with_code_language[:definition].match(definition)

  @presenter = Presenters::Home.new(
    title: 'Nexmo Developer',
    env: Sinatra::Application.environment,
  )
  @specification = Presenters::Specification.new(
    definition_name: definition,
    expand_responses: params.fetch(:expandResponses, nil),
  )
  erb :'open_api/show'
end

get '/api/*/?' do
  erb "api #{params[:splat].join("/")}"
end
