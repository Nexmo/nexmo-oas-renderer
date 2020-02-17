module Nexmo
  module OAS
    module Renderer
      module Presenters
        class RequestBodyRaw
          def initialize(parameters)
            @parameters = parameters
          end

          def to_json
            JSON.pretty_generate(generate_request)
          end

          def generate_request(parameters = nil)
            parameters ||= @parameters
            output = {}

            parameters.each do |parameter|
              if parameter.collection?
                nested_output = generate_request(parameter.properties)
                next unless nested_output.keys.length.positive?
                output[parameter.name] = nested_output
              else
                next unless parameter.example
                example = parameter.example
                if parameter.example.is_a?(String)
                  # Remove line breaks
                  example = example.gsub('<br />', ' ')
                end
                output[parameter.name] = example
              end
            end
            output
          end
        end
      end
    end
  end
end
