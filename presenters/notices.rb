require 'yaml'

module Presenters
  class Notices
    include Enumerable

    def initialize(request_path)
      @request_path = request_path
      @notices      = ::YAML.load_file("#{::Sinatra::Application.root}/config/notices.yml")
    end

    def each(&block)
      (@notices || {}).each do |id, config|
        block.call(Notice.new(id, config, @request_path))
      end
    end

    class Notice
      attr_reader :id

      def initialize(id, config, request_path)
        @id           = id
        @config       = config
        @request_path = request_path
      end

      def dismissible?
        @config['dismissible']
      end

      def content
        @config['content']
      end

      def show?
        path.nil? || @request_path.match(Regexp.new(path))
      end

      def path
        @path ||= @config['path']
      end
    end
  end
end
