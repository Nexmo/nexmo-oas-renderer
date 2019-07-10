require 'oas_parser'
require 'nexmo/oas/renderer/presenters/formats'

RSpec.describe Nexmo::OAS::Renderer::Presenters::Formats do

  describe '#extract' do
    let(:path) { 'spec/fixtures/petstore-multiple-response.yml' }

    let(:responses) { OasParser::Definition.resolve(path).endpoints.flat_map(&:responses) }

    it 'returns a hash with the formats of the responses' do
      expect(described_class.new(responses).extract).to match(
        'application/json' => 'JSON',
        'application/xml'  => 'XML',
        'text/xml'         => 'XML',
      )
    end
  end

end
