# Processes a document in the background: chunking + TF-IDF vectorization.
#
# Transitions: pending → processing → ready (or failed on error).
# Retries up to 3 times with exponential backoff before marking as failed.
class DocumentProcessingJob < ApplicationJob
  queue_as :default

  retry_on StandardError, wait: :polynomially_longer, attempts: 3 do |job, error|
    document = Document.find_by(id: job.arguments.first)
    document&.update!(status: "failed")
    Rails.logger.error("DocumentProcessingJob: Permanently failed for Document ##{job.arguments.first} — #{error.message}")
  end

  discard_on ActiveRecord::RecordNotFound

  def perform(document_id)
    document = Document.find(document_id)

    return if document.ready?

    document.update!(status: "processing")
    document.process!
    document.update!(status: "ready")

    Rails.logger.info("DocumentProcessingJob: Completed Document ##{document_id} (#{document.chunk_count} chunks)")
  end
end
