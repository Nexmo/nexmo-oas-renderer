require 'yaml'

module Nexmo
  module OAS
    module Renderer
      module Constraints
        class Redirector
          REDIRECTS = YAML.load_file(File.expand_path("../config/redirects.yml", __dir__)) || {}

          def self.find(request)
            REDIRECTS[request.path] || false
          end
        end
      end
    end
  end
end
