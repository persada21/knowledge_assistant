require "rails_helper"

RSpec.describe "Questions", type: :request do
  describe "POST /questions" do
    context "with a blank question" do
      it "redirects back with an alert" do
        post questions_path, params: { question: "  " }

        expect(response).to redirect_to(new_question_path)
        follow_redirect!
        expect(response.body).to include("Please enter a question")
      end
    end

    context "when no documents are ready" do
      it "redirects back with an alert" do
        post questions_path, params: { question: "What is Rails?" }

        expect(response).to redirect_to(new_question_path)
        follow_redirect!
        expect(response.body).to include("No documents are ready yet")
      end
    end

    context "when documents are ready" do
      before do
        doc = create(:document, status: "ready")
        doc.process!
      end

      it "renders the answer page" do
        post questions_path, params: { question: "Rails framework" }

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Confidence")
        expect(response.body).to include("Sources")
      end

      it "shows a no-results message for unrelated queries" do
        post questions_path, params: { question: "xyzzy qqqqq zzzzz" }

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("No relevant content found").or include("no relevant content")
      end
    end
  end
end
