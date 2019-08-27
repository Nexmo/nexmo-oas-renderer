require 'nexmo/oas/renderer/presenters/response_tab/panel'
require 'nexmo/oas/renderer/decorators/response_parser_decorator'

RSpec.describe Nexmo::OAS::Renderer::Presenters::ResponseTab::Panel do
  let(:format) { 'application/json' }

  describe '#css_classes' do
    let(:schema) { {} }
    let(:content) { :responses }

    subject { described_class.new(schema: schema, index: index, content: content, format: format) }

    context 'when the index is 0' do
      let(:index) { 0 }

      it 'includes the active class' do
        expect(subject.css_classes).to eq('Vlt-tabs__panel Vlt-tabs__panel_active')
      end
    end

    context 'otherwise' do
      let(:index) { 1 }

      it 'returns the basic class' do
        expect(subject.css_classes).to eq('Vlt-tabs__panel')
      end
    end
  end

  describe '#content' do
    let(:index) { 0 }
    let(:schema) { {} }

    subject { described_class.new(schema: schema, index: index, content: content, format: format) }

    context ':responses' do
      let(:content) { :responses }

      it 'returns the parsed response' do
        decorator = instance_double(Nexmo::OAS::Renderer::ResponseParserDecorator)
        expect(Nexmo::OAS::Renderer::ResponseParserDecorator).to receive(:new).with(schema).and_return(decorator)
        expect(decorator).to receive(:html).with(format, xml_options: schema['xml'])

        subject.content
      end
    end

    context 'otherwise' do
      let(:content) { :code }

      it 'returns the response fields' do
        expect(subject.content).to eq([
          :'open_api/_response_fields',
          locals: { schema: schema, index: index, format: format }
        ])
      end
    end
  end
end
