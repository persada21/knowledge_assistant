# Splits document text into overlapping chunks for retrieval.
#
# Pipeline: paragraphs → enforce max size → add overlap
# Overlap ensures answers near chunk boundaries are not lost.
class Chunker
  MAX_WORDS = 150

  def self.call(text)
    new(text).call
  end

  def initialize(text)
    @text = text
  end

  def call
    raw       = split_into_paragraphs
    sized     = enforce_max_size(raw)
    fragments = add_overlap(sized)

    fragments.each_with_index.map do |body, idx|
      { body: body.strip, index: idx + 1 }
    end
  end

  private

  def split_into_paragraphs
    @text.split(/\n\n+/).map(&:strip).reject(&:empty?)
  end

  # Break any paragraph exceeding MAX_WORDS into groups of 3 sentences.
  def enforce_max_size(paragraphs)
    paragraphs.flat_map do |para|
      next [para] unless para.split.size > MAX_WORDS

      para.split(/(?<=[.!?])\s+/).each_slice(3).map { |group| group.join(" ") }
    end
  end

  # Append the first sentence of the next chunk to each chunk.
  def add_overlap(chunks)
    return chunks if chunks.size <= 1

    chunks.each_with_index.map do |chunk, i|
      next chunk if i == chunks.size - 1

      next_sentence = chunks[i + 1].split(/(?<=[.!?])\s+/).first.to_s
      "#{chunk} #{next_sentence}".strip
    end
  end
end
