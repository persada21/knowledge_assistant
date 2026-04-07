require "rails_helper"

RSpec.describe Vectorizer do
  describe ".call" do
    it "returns a hash of word scores" do
      result = described_class.call("Rails is a web framework")

      expect(result).to be_a(Hash)
      expect(result.values).to all(be_a(Float))
    end

    it "removes stopwords" do
      result = described_class.call("the cat sat on the mat")

      expect(result.keys).not_to include("the", "on")
    end

    it "ignores words shorter than 3 characters" do
      result = described_class.call("I go to do it up")

      expect(result).to be_empty
    end

    it "gives higher score to rare words with IDF" do
      all_texts = [
        "common word appears here",
        "common word appears again",
        "saffron appears once"
      ]
      result = described_class.call("saffron", all_texts)

      expect(result["saffron"]).to be > 0
    end

    it "returns empty hash for empty input" do
      expect(described_class.call("")).to eq({})
    end

    it "returns TF-only scores when no corpus is provided" do
      result = described_class.call("ruby ruby python")

      expect(result["ruby"]).to be > result["python"]
    end
  end
end
