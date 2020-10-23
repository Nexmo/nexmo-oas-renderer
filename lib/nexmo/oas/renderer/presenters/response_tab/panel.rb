# frozen_string_literal: true

module Nexmo
  module OAS
    module Renderer
      module Presenters
        module ResponseTab
          class Panel
            attr_reader :index

            def initialize(schema:, index:, format:, content:, endpoint:, theme_light: nil) # rubocop:disable Metrics/ParameterLists
              @schema  = schema
              @index   = index
              @format  = format
              @content = content
              @endpoint = endpoint
              @theme_light = theme_light
            end

            def css_classes
              classes = ['Vlt-tabs__panel']
              classes << 'Vlt-tabs__panel_active' if @index.zero?
              classes.join(' ')
            end

            def content
              if @content == :responses
                return generate_examples(@schema['examples']) if @schema['examples'] && @format == 'application/json'

                Nexmo::OAS::Renderer::ResponseParserDecorator
                  .new(@schema)
                  .html(@format, xml_options: @schema['xml'], theme_light: @theme_light)
              else
                [:'open_api/_response_fields', locals: {
                  schema: @schema,
                  index: @index,
                  format: @format,
                  endpoint: @endpoint,
                }]
              end
            end

            def generate_examples(examples)
              switcher = Nexmo::OAS::Renderer::Presenters::ContentSwitcher.new(label: "Example", format: @format, force_type: 'dropdown', theme_light: @theme_light)

              examples.each_with_index do |v,k|
              response = JSON.neat_generate(v[1], {
                  wrap: true,
                  after_colon: 1,
              })
              content = <<~HEREDOC
                <pre class="pre-wrap language-json #{@theme_light ? 'Vlt-prism--dark' : ''} Vlt-prism--copy-disabled"><code>#{response}</code></pre>
              HEREDOC
                 switcher.add_content(
                    title: v[0].titleize,
                    content: content,
                    tab_id: v[0],
                    active: k == 0
                )
              end

              switcher.render
            end
          end
        end
      end
    end
  end
end
