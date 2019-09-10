module Nexmo
  module OAS
    module Renderer
      module Presenters
        module ResponseTab
          class Panel
            attr_reader :index

            def initialize(schema:, index:, format:, content:, endpoint:)
              @schema  = schema
              @index   = index
              @format  = format
              @content = content
              @endpoint = endpoint
            end

            def css_classes
              classes = ['Vlt-tabs__panel']
              classes << 'Vlt-tabs__panel_active' if @index.zero?
              classes.join(' ')
            end

            def content
              if @content == :responses
                Nexmo::OAS::Renderer::ResponseParserDecorator.
                  new(@schema).
                  html(@format, xml_options: @schema['xml'])
              else
                [:'open_api/_response_fields', locals: {
                  schema: @schema,
                  index: @index,
                  format: @format,
                  endpoint: @endpoint
                }]
              end
            end
          end
        end
      end
    end
  end
end
