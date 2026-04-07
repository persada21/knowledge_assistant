class Chunk < ApplicationRecord
  belongs_to :document

  validates :body, presence: true
  validates :chunk_index, presence: true

  def vector
    super || {}
  end
end
