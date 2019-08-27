require 'nexmo/oas/renderer/presenters/response_tab/link'

RSpec.describe Nexmo::OAS::Renderer::Presenters::ResponseTab::Link do
  describe '#css_classes' do
    let(:schema) { {} }

    subject { described_class.new(schema: schema, index: index) }

    context 'when the index is 0' do
      let(:index) { 0 }

      it 'includes the active class' do
        expect(subject.css_classes).to eq('Vlt-tabs__link Vlt-tabs__link_active')
      end
    end

    context 'otherwise' do
      let(:index) { 1 }

      it 'returns the basic class' do
        expect(subject.css_classes).to eq('Vlt-tabs__link')
      end
    end
  end

  describe '#content' do
    let(:index) { 0 }

    subject { described_class.new(schema: schema, index: index) }

    context 'with a description' do
      let(:schema) do
        { 'description' => 'Response description' }
      end

      it 'returns the description' do
        expect(subject.content).to eq('Response description')
      end
    end

    context 'otherwise' do
      let(:schema) { {} }

      it 'returns a placeholder' do
        expect(subject.content).to eq('Response 1')
      end
    end
  end
end
