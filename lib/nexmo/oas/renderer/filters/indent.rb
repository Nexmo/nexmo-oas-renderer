module Nexmo
  module OAS
    module Renderer
      module Filters
        class Indent < Banzai::Filter
          def call(input)
            input.gsub(/^^\s{4}\-\>\s(.+?)$/) do
              body = MarkdownPipeline.new.call($1)
              <<~HEREDOC
                <div class="indent">
                  #{body}
                </div>
              HEREDOC
            end
          end
        end
      end
    end
  end
end
