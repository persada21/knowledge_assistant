class Document < ApplicationRecord
  STATUSES = %w[pending processing ready failed].freeze

  has_many :chunks, dependent: :destroy

  validates :title, presence: true
  validates :original_text, presence: true, length: { minimum: 50 }
  validates :status, inclusion: { in: STATUSES }

  scope :ready, -> { where(status: "ready") }

  STATUSES.each do |name|
    define_method(:"#{name}?") { status == name }
  end

  # Runs the full processing pipeline: chunk → vectorize → store
  def process!
    chunks.destroy_all

    chunk_data = Chunker.call(original_text)
    all_bodies = chunk_data.pluck(:body)

    chunk_data.each do |data|
      chunks.create!(
        body:        data[:body],
        chunk_index: data[:index],
        vector:      Vectorizer.call(data[:body], all_bodies),
        word_count:  data[:body].split.size
      )
    end

    update!(chunk_count: chunks.count)
  end
end
