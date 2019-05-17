require_relative '../helpers/navigation'

module Presenters
  class Navigation
    include ::Helpers::Navigation

    attr_reader :title, :content

    def initialize(content:, title: nil)
      @content = content
      @title   = title
    end

    def navigation_from_content
      super(content: @content, title: @title)
    end
  end
end
