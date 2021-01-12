# frozen_string_literal: true

require_relative './response_tab/link'
require_relative './response_tab/panel'

module Nexmo
  module OAS
    module Renderer
      module Presenters
        class ResponseTabs
          attr_reader :format, :switcher

          def initialize(format, response, content, endpoint, theme_light: nil)
            @format   = format
            @response = response
            @content  = content
            @endpoint = endpoint
            @theme_light = theme_light
            @switcher ||= @response.schema(@format)['x-switcher']
          end

          def tab_links
            @tab_links ||= @response.split_schemas(@format).map.with_index do |schema, index|
              schema = handle_all_of(schema)
              ResponseTab::Link.new(
                index: index,
                schema: schema
              )
            end
          end

          def tab_panels
            @tab_panels ||= @response.split_schemas(@format).map.with_index do |schema, index|
              schema = handle_all_of(schema)
              examples = examples_for_schema(schema)
              ResponseTab::Panel.new(
                schema: schema,
                index: index,
                format: @format,
                content: examples || @content,
                endpoint: @endpoint,
                theme_light: @theme_light
              )
            end
          end

          def examples_for_schema(schema)
            # If there are any examples, show them
            examples = @response.raw.dig('content', @format, 'examples')
            return nil unless @content == :responses && @format == 'application/json' && examples

            example_switcher = Nexmo::OAS::Renderer::Presenters::ContentSwitcher.new(format: format, force_type: 'dropdown', theme_light: @theme_light)

            has_visible_panel = false
            examples.each_with_index do |v, _k|
              # Only if the example key is listed in x-examples in the schema
              next unless schema['x-examples']&.include?(v[0])

              response = JSON.neat_generate(v[1], {
                  wrap: true,
                  after_colon: 1,
              })

              content = <<~HEREDOC
                <pre class="pre-wrap language-json #{@theme_light ? 'Vlt-prism--dark' : ''} Vlt-prism--copy-disabled"><code>#{response}</code></pre>
              HEREDOC

              example_switcher.add_content(
                title: v[0].titleize,
                content: content,
                tab_id: v[0],
                active: !has_visible_panel
              )
              has_visible_panel = true
            end
            return example_switcher if example_switcher.panels.size.positive?
          end

          def handle_all_of(schema)
            if schema['allOf']
              schema['allOf'].each do |p|
                schema.deep_merge!(p)
              end
              schema.delete('allOf')
            end
            schema
          end
        end
      end
    end
  end
end
