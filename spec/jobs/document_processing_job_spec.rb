require "rails_helper"

RSpec.describe DocumentProcessingJob, type: :job do
  let(:document) { create(:document) }

  describe "#perform" do
    it "processes the document and sets status to ready" do
      described_class.perform_now(document.id)

      document.reload
      expect(document.status).to eq("ready")
      expect(document.chunk_count).to be > 0
    end

    it "transitions status from pending through processing to ready" do
      statuses = []
      allow_any_instance_of(Document).to receive(:update!).and_wrap_original do |method, **args|
        statuses << args[:status] if args[:status]
        method.call(**args)
      end

      described_class.perform_now(document.id)

      expect(statuses).to include("processing", "ready")
    end

    it "skips if document is already ready" do
      document.update!(status: "ready")

      expect { described_class.perform_now(document.id) }.not_to(change { document.reload.chunk_count })
    end

    it "does not raise if document does not exist" do
      expect { described_class.perform_now(-1) }.not_to raise_error
    end
  end
end
