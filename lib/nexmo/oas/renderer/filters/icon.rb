module Nexmo
  module OAS
    module Renderer
      module Filters
        class Icon < Banzai::Filter
          def call(input)
            input.gsub!('✅', '<svg class="Vlt-green Vlt-icon Vlt-icon--small"><use xlink:href="/assets/symbol/volta-icons.svg#Vlt-icon-check" /></svg>')
            input.gsub!('❌', '<svg class="Vlt-red Vlt-icon Vlt-icon--small"><use xlink:href="/assets/symbol/volta-icons.svg#Vlt-icon-cross" /></svg>')

            input.gsub!(/\[icon="(.+?)"\]/) do
              <<~HEREDOC
                <svg class="Vlt-green Vlt-icon Vlt-icon--small"><use xlink:href="/assets/symbol/volta-icons.svg#Vlt-icon-#{$1}" /></svg>
              HEREDOC
            end

            input
          end
        end
      end
    end
  end
end
