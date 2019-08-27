require_relative './response_tab/link'
require_relative './response_tab/panel'

module Nexmo
  module OAS
    module Renderer
      module Presenters
        class ResponseTabs
          attr_reader :format

          def initialize(format, response, content)
            @format   = format
            @response = response
            @content  = content
          end

          def tab_links
            @tab_links ||= @response.split_schemas(@format).map.with_index do |schema, index|
              ResponseTab::Link.new(
                index: index,
                schema: schema
              )
            end
          end

          def tab_panels
            @tab_panels ||= @response.split_schemas(@format).map.with_index do |schema, index|
              ResponseTab::Panel.new(
                schema: schema,
                index: index,
                format: @format,
                content: @content
              )
            end
          end
        end
      end
    end
  end
end
