module Helpers
  module URL
    def parameter_values(enum)
      enum.map { |value| "<code>#{value}</code>" }.to_sentence(last_word_connector: ' or ', two_words_connector: ' or ')
    end

    def canonical_path
      request.path.chomp("/#{params[:code_language]}")
    end
  end
end
