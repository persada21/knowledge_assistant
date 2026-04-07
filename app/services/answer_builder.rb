# Assembles a readable answer from retrieved chunks, with sources.
class AnswerBuilder
  def self.call(question, results)
    new(question, results).call
  end

  def initialize(question, results)
    @question = question
    @results  = results
  end

  def call
    return no_answer if @results.empty?

    {
      question:   @question,
      answer:     build_answer,
      confidence: @results.first[:score],
      sources:    build_sources
    }
  end

  private

  def build_answer
    @results.each_with_index.map do |result, i|
      prefix = i.zero? ? "Based on the uploaded content" : "Additionally"
      "#{prefix}: #{result[:chunk].body.strip}"
    end.join("\n\n")
  end

  def build_sources
    @results.map do |result|
      {
        document_title: result[:chunk].document.title,
        section:        result[:chunk].chunk_index,
        score:          result[:score]
      }
    end
  end

  def no_answer
    {
      question:   @question,
      answer:     "Sorry, no relevant content was found for your question. Try rephrasing or uploading more content.",
      confidence: 0.0,
      sources:    []
    }
  end
end
