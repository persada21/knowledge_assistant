# Finds the most relevant chunks for a given question.
#
# 1. Vectorizes the question using the same TF-IDF pipeline
# 2. Compares against stored chunks (from ready documents only) via cosine similarity
# 3. Returns top-K results above a minimum confidence threshold
class Retriever
  TOP_K         = 3
  MINIMUM_SCORE = 0.05

  def self.call(question)
    new(question).call
  end

  def initialize(question)
    @question = question
  end

  def call
    searchable   = Chunk.joins(:document).where(documents: { status: "ready" })
    all_bodies   = searchable.pluck(:body)
    query_vector = Vectorizer.call(@question, all_bodies)

    return [] if query_vector.empty?

    ranked_chunks(searchable, query_vector)
  end

  private

  def ranked_chunks(scope, query_vector)
    scope.includes(:document).filter_map do |chunk|
      score = cosine_similarity(query_vector, chunk.vector)
      { chunk: chunk, score: score.round(4) } if score >= MINIMUM_SCORE
    end.sort_by { |r| -r[:score] }.first(TOP_K)
  end

  # Cosine similarity: 0.0 = no overlap, 1.0 = identical direction
  def cosine_similarity(vec_a, vec_b)
    shared = vec_a.keys & vec_b.keys
    return 0.0 if shared.empty?

    dot   = shared.sum { |w| vec_a[w] * vec_b[w].to_f }
    mag_a = Math.sqrt(vec_a.values.sum { |v| v**2 })
    mag_b = Math.sqrt(vec_b.values.sum { |v| v**2 })

    return 0.0 if mag_a.zero? || mag_b.zero?

    dot / (mag_a * mag_b)
  end
end
