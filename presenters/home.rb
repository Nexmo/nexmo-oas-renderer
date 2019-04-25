module Presenters
  class Home
    attr_reader :title, :environment

    def initialize(title:, env:)
      @environment = env
      @title       = title
    end

    def search_enabled?
      defined?(ALGOLIA_CONFIG) && ENV['ALGOLIA_SEARCH_KEY']
    end
  end
end
