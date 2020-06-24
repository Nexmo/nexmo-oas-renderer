module Nexmo
  module OAS
    module Renderer
      module Presenters
        class RequestBodyRaw
          def initialize(parameters, options = {}, endpoint = nil)
            @parameters = parameters
            @options = options
            @endpoint = endpoint
          end

          def to_format(format)
            return to_urlencoded if format == "application/x-www-form-urlencoded"
            return to_json
          end

          def to_urlencoded

            example = ""
            body = URI.encode_www_form(generate_request)
            if @endpoint
              servers = @endpoint.path.servers ? @endpoint.path.servers : @endpoint.definition.servers
              path = @endpoint.path.path.gsub(/\{(.+?)\}/, ':\1')
              uri = URI("#{servers[0]['url']}#{path}")
              example += "#{@endpoint.method.upcase} #{uri.path} HTTP/1.1\n"
              example += "Host: #{uri.host} \n"
              example += "Content-Type: application/x-www-form-urlencoded\n"
              example += "Content-Length: #{body.length}\n"
              example += "\n"
            end
            example += body
            example
          end

          def to_json
            JSON.pretty_generate(generate_request)
          end

          def generate_request(parameters = nil, options = nil)
            parameters ||= @parameters
            options ||= @options
            output = {}

            parameters.each do |parameter|
              next if options['required_only'] && optional?(parameter, options['required'])

              parameter_name = name(parameter)
              param = parameter


              # This is all required to handle an edge case where parameter.name is an OasParser::Property
              # Which happens when you use a oneOf inside items in a property.
              # I believe this is a bug, but it's a BC break in the parser

              it = nil
              required = []
              if parameter_name.instance_of?(OasParser::Property)
                parameter_name = parameter.owner.name
                it = parameter.schema['items']
                required = parameter.name.schema['required']

                param = OasParser::Parameter.new(parameter_name, parameter.schema)
              end

              if param.raw['items'] && param.raw['example']
                output[parameter_name] = param.raw['example']
              elsif param.raw['items'] && param.raw['items']['oneOf']
                param = param.raw['items']['oneOf'][0]
                output[parameter_name] = [generate_request(properties(param).map {|p| p.name})]
              elsif collection?(param) && hasProperties?(param)
                nested_output = generate_request(properties(param))
                next unless nested_output.keys.length.positive?
                nested_output = [nested_output] if param.array?
                output[parameter_name] = nested_output
              else
                ex = example(param)
                next unless ex
                if ex.is_a?(String)
                  # Remove line breaks
                  ex = ex.gsub('<br />', ' ')
                end
                output[parameter_name] = ex
              end
            end
            output
          end

          def items(parameter)
            if !parameter.respond_to?(:items)
              return parameter['items']
            end

            parameter.items
          end


          def example(parameter)
            if !parameter.respond_to?(:example)
              return parameter['example']
            end

            parameter.example
          end

          def name(parameter)
            if !parameter.respond_to?(:name)
              return parameter['name']
            end

            parameter.name
          end

          def properties(parameter)
            if !parameter.respond_to?(:properties)
              return parameter['properties']
            end
            parameter.properties
          end

          def array?(parameter)
            if !parameter.respond_to?(:array?)
              return parameter['items']
            end

            parameter.array?
          end

          def collection?(parameter)
            if !parameter.respond_to?(:collection?)
              return parameter['properties']
            end

            parameter.collection?
          end

          def hasProperties?(parameter)
            if !parameter.respond_to?(:collection?)
              return parameter['properties']
            end

            parameter.properties.size.positive?
          end

          def optional?(parameter, allowList)
            return false if allowList && allowList.include?(name(parameter))

            if !parameter.respond_to?(:required)
              return false
            end

            if !parameter.schema
              return false
            end

            return !parameter.required
          end
        end
      end
    end
  end
end
