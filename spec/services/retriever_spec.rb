require "rails_helper"

RSpec.describe Retriever do
  describe ".call" do
    it "returns empty array when no chunks exist" do
      expect(described_class.call("any question")).to eq([])
    end

    it "returns results with :chunk and :score keys" do
      doc = create(:document, status: "ready")
      doc.process!

      results = described_class.call("What is Rails?")

      expect(results).to be_an(Array)
      results.each do |r|
        expect(r).to include(:chunk, :score)
        expect(r[:chunk]).to be_a(Chunk)
        expect(r[:score]).to be_a(Float)
      end
    end

    it "returns at most TOP_K results" do
      doc = create(:document, status: "ready")
      doc.process!

      results = described_class.call("web framework")

      expect(results.size).to be <= described_class::TOP_K
    end

    it "only searches chunks from ready documents" do
      pending_doc = create(:document, status: "pending")
      pending_doc.process!

      expect(described_class.call("Rails framework")).to eq([])
    end

    it "ranks more relevant chunks higher" do
      doc = create(:document, status: "ready")
      doc.process!

      results = described_class.call("Rails framework")

      next if results.size < 2

      scores = results.pluck(:score)
      expect(scores).to eq(scores.sort.reverse)
    end
  end
end
