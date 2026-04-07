require "rails_helper"

RSpec.describe Document, type: :model do
  describe "validations" do
    it { expect(build(:document)).to be_valid }

    it "requires a title" do
      doc = build(:document, title: "")
      expect(doc).not_to be_valid
      expect(doc.errors[:title]).to include("can't be blank")
    end

    it "requires original_text with minimum 50 characters" do
      doc = build(:document, original_text: "Too short")
      expect(doc).not_to be_valid
    end

    it "validates status inclusion" do
      doc = build(:document)
      doc.status = "invalid"
      expect(doc).not_to be_valid
    end
  end

  describe "status helpers" do
    it "defaults to pending" do
      expect(described_class.new.status).to eq("pending")
    end

    it "responds to status query methods" do
      doc = build(:document)
      expect(doc.pending?).to be true
      expect(doc.ready?).to be false
    end
  end

  describe ".ready scope" do
    it "returns only ready documents" do
      create(:document, status: "ready")
      create(:document, status: "pending")

      expect(described_class.ready.count).to eq(1)
    end
  end

  describe "associations" do
    it "destroys associated chunks" do
      doc = create(:document, status: "ready")
      doc.process!

      expect { doc.destroy }.to change(Chunk, :count).to(0)
    end
  end

  describe "#process!" do
    it "creates chunks from the document text" do
      doc = create(:document)

      expect { doc.process! }.to change(Chunk, :count).from(0)
      expect(doc.reload.chunk_count).to be > 0
    end

    it "replaces old chunks on re-processing" do
      doc = create(:document)
      doc.process!
      original_count = doc.chunk_count

      doc.process!

      expect(doc.reload.chunk_count).to eq(original_count)
    end
  end
end
