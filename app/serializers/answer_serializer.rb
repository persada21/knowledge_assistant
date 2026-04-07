class AnswerSerializer
  def initialize(answer)
    @answer = answer
  end

  def as_json(_options = {})
    {
      data: {
        question:   @answer[:question],
        answer:     @answer[:answer],
        confidence: @answer[:confidence],
        sources:    serialized_sources
      }
    }
  end

  private

  def serialized_sources
    @answer[:sources].map.with_index(1) do |source, rank|
      {
        rank:           rank,
        document_title: source[:document_title],
        section:        source[:section],
        score:          source[:score]
      }
    end
  end
end
