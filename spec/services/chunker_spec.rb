require "rails_helper"

RSpec.describe Chunker do
  describe ".call" do
    it "splits text into chunks by paragraph" do
      text = "First paragraph here.\n\nSecond paragraph here.\n\nThird one."
      chunks = described_class.call(text)

      expect(chunks.size).to be >= 2
      expect(chunks.first[:index]).to eq(1)
    end

    it "returns chunks with :body and :index keys" do
      chunks = described_class.call("Hello world. This is a test.\n\nSecond part here.")

      expect(chunks.first).to include(:body, :index)
    end

    it "does not return empty chunks" do
      chunks = described_class.call("One paragraph.\n\n\n\nAnother paragraph.")

      chunks.each { |c| expect(c[:body]).not_to be_empty }
    end

    it "adds overlap from the next chunk" do
      text = "First paragraph sentence one. Sentence two.\n\nSecond paragraph sentence one. Sentence two."
      chunks = described_class.call(text)

      # First chunk should contain content from the second chunk
      expect(chunks.first[:body]).to include("Second paragraph")
    end

    it "handles a single paragraph without errors" do
      chunks = described_class.call("Just one paragraph with no breaks at all.")

      expect(chunks.size).to eq(1)
      expect(chunks.first[:body]).to eq("Just one paragraph with no breaks at all.")
    end

    it "handles text with no punctuation" do
      text = "no periods or commas just words flowing on and on\n\nanother block of words here"
      chunks = described_class.call(text)

      expect(chunks.size).to be >= 2
      chunks.each { |c| expect(c[:body]).not_to be_empty }
    end

    it "splits a very long paragraph that exceeds MAX_WORDS" do
      long_para = (["This is sentence number one."] * 60).join(" ")
      chunks = described_class.call(long_para)

      expect(chunks.size).to be > 1
      chunks.each { |c| expect(c[:body].split.size).to be <= Chunker::MAX_WORDS + 30 }
    end

    it "handles whitespace-only input gracefully" do
      chunks = described_class.call("   \n\n   \n\n   ")

      expect(chunks).to be_empty
    end
  end
end
