class DocumentsController < ApplicationController
  def index
    @documents = Document.order(created_at: :desc)
  end

  def show
    @document = Document.find(params[:id])
    @chunks   = @document.chunks.order(:chunk_index)
  end

  def new
    @document = Document.new
  end

  def create
    @document = Document.new(document_params)
    @document.original_text = params[:document][:file].read if params.dig(:document, :file).present?

    if @document.save
      DocumentProcessingJob.perform_later(@document.id)
      redirect_to @document, notice: "Document uploaded! Processing in the background..."
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  def document_params
    params.expect(document: [:title, :original_text])
  end
end
