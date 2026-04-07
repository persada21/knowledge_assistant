class PagesController < ApplicationController
  def home
    @recent_documents = Document.order(created_at: :desc).limit(5)
    @total_documents  = Document.count
    @total_chunks     = Chunk.count
  end
end
