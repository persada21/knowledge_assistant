require "rails_helper"

RSpec.describe Chunk, type: :model do
  describe "validations" do
    it { expect(build(:chunk)).to be_valid }

    it "requires a body" do
      chunk = build(:chunk, body: "")
      expect(chunk).not_to be_valid
    end

    it "requires a chunk_index" do
      chunk = build(:chunk, chunk_index: nil)
      expect(chunk).not_to be_valid
    end
  end

  describe "#vector" do
    it "returns empty hash when vector is nil" do
      chunk = build(:chunk, vector: nil)
      expect(chunk.vector).to eq({})
    end

    it "returns stored vector hash" do
      chunk = build(:chunk, vector: { "ruby" => 0.5 })
      expect(chunk.vector).to eq({ "ruby" => 0.5 })
    end
  end
end
