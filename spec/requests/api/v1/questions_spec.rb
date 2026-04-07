require "rails_helper"

RSpec.describe "Api::V1::Questions", type: :request do
  describe "POST /api/v1/questions" do
    context "when question is blank" do
      it "returns 422 with error message" do
        post api_v1_questions_path, params: { question: "" }

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.parsed_body["error"]).to eq("Question is required.")
      end
    end

    context "when no documents are ready" do
      it "returns 503 with error message" do
        post api_v1_questions_path, params: { question: "What is Rails?" }

        expect(response).to have_http_status(:service_unavailable)
        expect(response.parsed_body["error"]).to eq("No documents are ready yet.")
      end
    end

    context "when documents are ready" do
      before do
        doc = create(:document, status: "ready")
        doc.process!
      end

      it "returns 200 with serialized answer" do
        post api_v1_questions_path, params: { question: "What is Rails?" }

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to have_key("data")

        data = response.parsed_body["data"]
        expect(data).to include("question", "answer", "confidence", "sources")
      end

      it "includes ranked sources with expected fields" do
        post api_v1_questions_path, params: { question: "web framework" }

        sources = response.parsed_body.dig("data", "sources")
        next if sources.empty?

        expect(sources).to all(include("rank", "document_title", "section", "score"))
      end

      it "returns confidence as a number between 0 and 1" do
        post api_v1_questions_path, params: { question: "Rails MVC" }

        confidence = response.parsed_body.dig("data", "confidence")
        expect(confidence).to be_a(Numeric)
        expect(confidence).to be_between(0, 1)
      end
    end
  end
end
