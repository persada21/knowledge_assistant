# Converts text into a TF-IDF word-score hash.
#
# TF  = how often a word appears in THIS text  (normalized 0..1)
# IDF = how rare a word is across ALL texts     (log-scaled)
# Score = TF × IDF — rare but frequent words rank highest.
class Vectorizer
  STOPWORDS = %w[
    a an the is are was were be been being
    have has had do does did will would could should
    may might shall can i me my we our you your
    he she it its they them their this that these those
    and or but if in on at to of for with by from
    up about into through during before after above below
    between each other all any both few more most other
    some such no not only own same than too very just
  ].to_set.freeze

  def self.call(text, all_texts = [])
    new(text, all_texts).call
  end

  def initialize(text, all_texts)
    @text      = text
    @all_texts = all_texts
  end

  def call
    tokens = tokenize(@text)
    return {} if tokens.empty?

    tf = term_frequency(tokens)

    return tf if @all_texts.empty?

    idf = inverse_document_frequency(tf.keys)
    tf.each_with_object({}) do |(word, tf_val), result|
      result[word] = (tf_val * idf[word]).round(6)
    end
  end

  private

  def tokenize(text)
    text.downcase
        .gsub(/[^a-z0-9\s]/, "")
        .split
        .reject { |w| STOPWORDS.include?(w) || w.length < 3 }
  end

  def term_frequency(tokens)
    total = tokens.size.to_f
    tokens.tally.transform_values { |count| count / total }
  end

  def inverse_document_frequency(words)
    total_docs = @all_texts.size.to_f + 1

    words.each_with_object({}) do |word, scores|
      docs_with_word = @all_texts.count { |t| t.downcase.include?(word) } + 1
      scores[word] = Math.log(total_docs / docs_with_word) + 1
    end
  end
end
