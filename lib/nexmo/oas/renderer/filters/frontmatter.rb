module Nexmo
  module OAS
    module Renderer
      module Filters
        class Frontmatter < Banzai::Filter
          def call(input)
            # Remove frontmatter from the input
            input.gsub(/\A(---.+?---)/mo, '')
          end
        end
      end
    end
  end
end
