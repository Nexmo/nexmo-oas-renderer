module Nexmo
  module OAS
    module Renderer
      module Filters
        class Break < Banzai::Filter
          def call(input)
            input.gsub('§', '<br>')
          end
        end
      end
    end
  end
end
