require "rails_helper"

RSpec.describe AnswerBuilder do
  describe ".call" do
    let(:document) { create(:document) }
    let(:chunk)    { create(:chunk, document: document) }

    it "returns a no-answer response when results are empty" do
      answer = described_class.call("anything", [])

      expect(answer[:confidence]).to eq(0.0)
      expect(answer[:sources]).to be_empty
      expect(answer[:answer]).to include("no relevant content")
    end

    it "builds an answer from results" do
      results = [{ chunk: chunk, score: 0.85 }]
      answer  = described_class.call("What is Rails?", results)

      expect(answer[:question]).to eq("What is Rails?")
      expect(answer[:confidence]).to eq(0.85)
      expect(answer[:answer]).to include("Based on the uploaded content")
      expect(answer[:sources].size).to eq(1)
    end

    it "includes correct source metadata" do
      results = [{ chunk: chunk, score: 0.6 }]
      answer  = described_class.call("test", results)
      source  = answer[:sources].first

      expect(source[:document_title]).to eq(document.title)
      expect(source[:section]).to eq(chunk.chunk_index)
      expect(source[:score]).to eq(0.6)
    end

    it "prefixes additional results with 'Additionally'" do
      chunk2  = create(:chunk, document: document, chunk_index: 2)
      results = [{ chunk: chunk, score: 0.8 }, { chunk: chunk2, score: 0.5 }]
      answer  = described_class.call("test", results)

      expect(answer[:answer]).to include("Additionally")
    end

    context "when multiple documents contribute chunks" do
      it "lists sources from each document with correct titles" do
        doc_a   = create(:document, title: "Alpha Guide")
        doc_b   = create(:document, title: "Beta Manual")
        chunk_a = create(:chunk, document: doc_a, chunk_index: 1)
        chunk_b = create(:chunk, document: doc_b, chunk_index: 1)
        results = [{ chunk: chunk_a, score: 0.9 }, { chunk: chunk_b, score: 0.7 }]

        answer = described_class.call("test", results)
        titles = answer[:sources].pluck(:document_title)

        expect(titles).to eq(["Alpha Guide", "Beta Manual"])
      end

      it "keeps sources ordered by score (highest first)" do
        doc_a   = create(:document, title: "Alpha")
        doc_b   = create(:document, title: "Beta")
        chunk_a = create(:chunk, document: doc_a, chunk_index: 1)
        chunk_b = create(:chunk, document: doc_b, chunk_index: 1)
        results = [{ chunk: chunk_a, score: 0.6 }, { chunk: chunk_b, score: 0.4 }]

        scores = described_class.call("test", results)[:sources].pluck(:score)

        expect(scores).to eq(scores.sort.reverse)
      end
    end
  end
end
