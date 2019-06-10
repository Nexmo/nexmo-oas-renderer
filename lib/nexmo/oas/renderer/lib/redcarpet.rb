require 'redcarpet'
require 'rouge'
require 'rouge/plugins/redcarpet'


module Nexmo
  module OAS
    module Renderer
      class HTML < Redcarpet::Render::HTML
        include Rouge::Plugins::Redcarpet
      end
    end
  end
end
