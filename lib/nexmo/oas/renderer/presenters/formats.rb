module Nexmo
  module OAS
    module Renderer
      module Presenters
        class Formats
          MAPPINGS = {
            'application/json' => 'JSON',
            'application/xml' => 'XML',
            'text/xml' => 'XML',
          }

          def initialize(responses)
            @responses = responses
          end

          def extract
            MAPPINGS.slice(*formats)
          end

          private

          def formats
            @formats ||= @responses.flat_map(&:formats).uniq
          end
        end
      end
    end
  end
end
