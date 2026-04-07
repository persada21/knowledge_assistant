require "rails_helper"

RSpec.describe AnswerSerializer do
  let(:answer) do
    {
      question:   "What is Rails?",
      answer:     "A web framework.",
      confidence: 0.85,
      sources:    [
        { document_title: "Doc A", section: 1, score: 0.9 },
        { document_title: "Doc B", section: 2, score: 0.7 }
      ]
    }
  end

  describe "#as_json" do
    it "wraps the response in a data envelope with answer fields" do
      data = described_class.new(answer).as_json[:data]

      expect(data[:question]).to eq("What is Rails?")
      expect(data[:answer]).to eq("A web framework.")
      expect(data[:confidence]).to eq(0.85)
    end

    it "adds rank to each source starting from 1" do
      sources = described_class.new(answer).as_json[:data][:sources]

      expect(sources.size).to eq(2)
      expect(sources.first[:rank]).to eq(1)
      expect(sources.last[:rank]).to eq(2)
    end

    it "handles empty sources" do
      empty = answer.merge(sources: [], confidence: 0.0)
      json  = described_class.new(empty).as_json

      expect(json[:data][:sources]).to eq([])
      expect(json[:data][:confidence]).to eq(0.0)
    end
  end
end
