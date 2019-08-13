module Nexmo
  module OAS
    module Renderer
      module Presenters
        module ResponseTab
          class Link
            attr_reader :index

            def initialize(index:, schema:)
              @index  = index
              @schema = schema
            end

            def css_classes
              classes = ['Vlt-tabs__link']
              classes << 'Vlt-tabs__link_active' if @index.zero?
              classes.join(' ')
            end

            def content
              @schema['description'] || "Response #{@index + 1}"
            end
          end
        end
      end
    end
  end
end
