require 'oas_parser'
require 'nexmo/oas/renderer/presenters/response_tabs'
require 'nexmo/oas/renderer/presenters/response_tab/link'

RSpec.describe Nexmo::OAS::Renderer::Presenters::ResponseTabs do
  let(:format)   { 'applications/json' }
  let(:content)  { :responses }
  let(:response) { instance_double(OasParser::Response) }
  let(:endpoint) { instance_double(OasParser::Endpoint) }

  before do
    expect(response).to receive(:schema).with(format).and_return({})
    expect(response).to receive(:split_schemas).with(format).and_return([{}, {}])
  end

  subject { described_class.new(format, response, content, endpoint) }

  describe '#tab_links' do
    it 'returns instances of ResponseTab::Link' do
      expect(subject.tab_links).to all(
        be_an_instance_of(Nexmo::OAS::Renderer::Presenters::ResponseTab::Link)
      )
    end
  end

  describe '#tab_panels' do
    it 'returns instances of ResponseTab::Panel' do
      expect(subject.tab_panels).to all(
        be_an_instance_of(Nexmo::OAS::Renderer::Presenters::ResponseTab::Panel)
      )
    end
  end
end
