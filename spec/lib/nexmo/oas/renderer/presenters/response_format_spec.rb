require 'nexmo/oas/renderer/presenters/response_format'

RSpec.describe Nexmo::OAS::Renderer::Presenters::ResponseFormat do
  describe '.to_dropdown' do
    let(:formats) { ['application/json', 'application/xml'] }

    it 'returns a hash with the different values' do
      expect(described_class.to_dropdown(formats)).to match(
        'application/json' => 'JSON',
        'application/xml'  => 'XML',
      )
    end
  end

  describe '#extract' do
    let(:code)     { '200' }
    let(:response) { YAML.safe_load(File.read('spec/fixtures/responses/200.yml')) }
    let(:responses) do
      [OasParser::Response.new(instance_double(OasParser::Endpoint), code, response[code])]
    end

    it 'extract the different formats from the responses' do
      expect(described_class.new(responses).extract).to match_array([
        'application/json', 'application/xml', 'text/xml', 'text/html'
      ])
    end
  end
end
