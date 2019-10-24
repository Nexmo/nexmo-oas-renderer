module Nexmo
  module OAS
    module Renderer
      module Presenters

        class Versions
          def initialize(definition_name)
            @definition_name = definition_name
          end

          def base_name
            @base_name ||= @definition_name.gsub(/\.v\d+/, '')
          end

          def current_version
            @current_version ||= begin
                                   m = /\.v(\d+)/.match(@definition_name)
                                   m.nil? ? '1' : m[1]
                                 end
          end

          def available_versions
            @available_versions ||= begin
                                      matches = definitions.select do |definition|
                                        definition.starts_with?(base_name) && !definition.include?("#{base_name}/")
                                      end

                                      matches.map do |definition|
                                        name = definition.chomp('.yml')
                                        m = /\.v(\d+)/.match(name)
                                        next { 'version' => '1', 'name' => name } unless m
                                        { 'version' => m[1], 'name' => name }

                                      end.sort_by { |v| v['version'] }
                                    end
          end

          def definitions
            @definitions ||= begin
                               Dir.glob("#{API.oas_path}/definitions/**/*.yml").map do |file|
                                 definition = file.sub("#{API.oas_path}/definitions/", '').chomp('.yml')
                               end
                             end
          end
        end

      end
    end
  end
end
