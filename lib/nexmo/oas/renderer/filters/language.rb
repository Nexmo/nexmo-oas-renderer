module Nexmo
  module OAS
    module Renderer
      module Filters
        class Language < Banzai::Filter
          def call(input)
            input.gsub(/\[(.+?)\]\(lang:.+?(?:'(.+?)'|"(.+?)")\)/) do |_s|
              "<span lang='#{$2}'>#{$1}</span>"
            end
          end
        end
      end
    end
  end
end
