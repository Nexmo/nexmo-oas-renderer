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
                                versions = Constraints::OpenApi.find_all_versions(base_name)
                                # Add in anything in the old /_api folder
                                if File.exist?("#{::Sinatra::Application.root}/_api/#{base_name}.md")
                                  versions.push({ 'version' => '1', 'name' => base_name })
                                end

                                versions.sort_by! { |v| v['version'] }
                              end
    end
  end

end
