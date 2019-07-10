require 'oas_parser'
require 'nexmo/oas/renderer/presenters/endpoint'

RSpec.describe Nexmo::OAS::Renderer::Presenters::Endpoint do
  let(:definition) { OasParser::Definition.resolve('spec/fixtures/petstore.yml') }
  let(:endpoint)   { definition.path_by_path('/pets/{id}').endpoint_by_method('get') }

  describe '#formats' do
    it 'extract the formats from the endpoint\'s responses' do
      expect(described_class.new(endpoint).formats).to match_array([
        'application/json', 'application/xml', 'text/xml', 'text/html'
      ])
    end
  end
end
