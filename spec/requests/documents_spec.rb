require "rails_helper"

RSpec.describe "Documents", type: :request do
  describe "POST /documents" do
    let(:valid_text) { "A" * 60 }

    context "with valid params" do
      it "creates a document and redirects to show" do
        expect do
          post documents_path, params: { document: { title: "My Doc", original_text: valid_text } }
        end.to change(Document, :count).by(1)

        expect(response).to redirect_to(document_path(Document.last))
        follow_redirect!
        expect(response.body).to include("Document uploaded")
      end

      it "enqueues a processing job" do
        expect do
          post documents_path, params: { document: { title: "My Doc", original_text: valid_text } }
        end.to have_enqueued_job(DocumentProcessingJob)
      end
    end

    context "with missing title" do
      it "renders the form with 422" do
        post documents_path, params: { document: { title: "", original_text: valid_text } }

        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context "with text too short" do
      it "renders the form with 422" do
        post documents_path, params: { document: { title: "Short", original_text: "Too short." } }

        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context "with a .txt file upload" do
      it "reads the file content into original_text" do
        file = Rack::Test::UploadedFile.new(
          StringIO.new(valid_text), "text/plain", false, original_filename: "notes.txt"
        )

        post documents_path, params: { document: { title: "From File", original_text: "", file: file } }

        doc = Document.last
        expect(doc.original_text).to eq(valid_text)
      end
    end
  end
end
