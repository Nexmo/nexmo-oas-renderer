require 'spec_helper'

describe NexmoApiSpecification::Definition do
  describe '#load' do
    it 'returns the specified definition' do
      expect(NexmoApiSpecification::Definition.load(:sms)).to include('title: SMS API')
      expect(NexmoApiSpecification::Definition.load(:conversation)).to include('title: Conversation API')
    end

    it 'returns false if the file does not exist' do
      expect(NexmoApiSpecification::Definition.load(:some_invalid_definition_name)).to eq(false)
    end
  end

  describe '#load!' do
    it 'returns the specified definition' do
      expect(NexmoApiSpecification::Definition.load!(:sms)).to include('title: SMS API')
      expect(NexmoApiSpecification::Definition.load!(:conversation)).to include('title: Conversation API')
    end

    it 'raises an exception if the file does not exist' do
      expect {
        NexmoApiSpecification::Definition.load!(:some_invalid_definition_name)
      }.to raise_error('Definition does not exist')
    end
  end

  describe '#path' do
    it 'returns the specified definition' do
      expect(NexmoApiSpecification::Definition.path(:sms)).to include('sms.yml')
      expect(NexmoApiSpecification::Definition.path(:conversation)).to include('conversation.yml')
      expect(NexmoApiSpecification::Definition.path(:some_invalid_definition_name)).to include('some_invalid_definition_name.yml')
    end
  end

  describe '#exists?' do
    it 'returns true if the definition exists' do
      expect(NexmoApiSpecification::Definition.exists?(:sms)).to eq(true)
      expect(NexmoApiSpecification::Definition.exists?(:conversation)).to eq(true)
    end

    it 'returns false if the definition does not exist' do
      expect(NexmoApiSpecification::Definition.load(:some_invalid_definition_name)).to eq(false)
    end
  end
end
