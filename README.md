# Knowledge Assistant (No External AI API)

A simple Rails app that lets users upload text documents and ask questions.
Answers are built using internal retrieval logic only (no OpenAI and no external AI API).

## How it works

```mermaid
flowchart LR
  subgraph Ingestion ["Ingestion (background job)"]
    direction TB
    A["POST /documents\nupload text"] --> B["Chunker\nsplit + overlap"]
    B --> C["Vectorizer\nTF-IDF word frequency"]
    C --> D[("PostgreSQL\nchunks + vectors")]
  end

  subgraph Retrieval ["Retrieval (on question)"]
    direction TB
    E["POST /questions\nuser question"] --> F["Retriever\ncosine similarity"]
    F --> G["AnswerBuilder\nmerge + cite sources"]
    G --> H["Response\nanswer + sources"]
  end

  D -. "lookup stored vectors" .-> F
```

**Left side** — user uploads a document. A background job splits it into chunks, computes TF-IDF vectors, and stores everything in PostgreSQL.

**Right side** — user asks a question. The retriever vectorizes the question, compares it against stored chunks via cosine similarity, and the answer builder assembles a response with sources.

## What this project does

1. **Content ingestion**
   - User uploads/pastes text.
   - Document is stored in `documents.original_text`.
   - A background job processes it.

2. **Chunking**
   - Text is split into paragraphs, then into smaller chunks.
   - Chunk overlap is added so context near boundaries is not lost.

3. **Embedding simulation**
   - Each chunk is converted into a local TF-IDF-like hash vector.
   - Stopwords are removed and scores are normalized.

4. **Retrieval**
   - User question is vectorized with the same logic.
   - Cosine similarity is calculated against stored chunks.
   - Top relevant chunks are selected.

5. **Answer generation**
   - Answer is composed from top chunks (extractive style).
   - Sources are included (`document_title`, section/chunk index, similarity score).

## Tech stack

- Ruby 3.4.4
- Rails 8
- PostgreSQL
- Sidekiq (background job processing)
- RSpec + RuboCop

## Quick setup

### 1) Install dependencies

```bash
bundle install
```

### 2) Configure environment

Create `.env` in the project root:

```bash
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_USERNAME=admin
DATABASE_PASSWORD=12345678
```

### 3) Prepare database

```bash
bin/rails db:create db:migrate
```

### 4) Seed sample documents (optional)

Three documents are included out of the box so you can try the app right away:

- Ruby on Rails History
- Computer History
- AI History

```bash
bin/rails db:seed
```

This will create the documents and process them (chunking + vectorization) immediately, so they are ready for questions as soon as the seed finishes.

Once seeded, try asking a question via the API:

```bash
curl -X POST http://localhost:3000/api/v1/questions \
  -H "Content-Type: application/json" \
  -d '{"question": "What is Ruby on Rails?"}'
```

Or open `http://localhost:3000/questions/new` in the browser and type "What is Ruby on Rails?"

### 5) Run app + worker

Terminal 1:

```bash
bin/rails server
```

Terminal 2:

```bash
bundle exec sidekiq
```

Open: `http://localhost:3000`

## How to use

1. Upload text (paste text or `.txt` file).
2. Wait until document status is `ready`.
3. Go to Ask Question page and submit a question.
4. Review answer + source list.

## JSON API

In addition to the web interface, there is a JSON endpoint to show how I would build an API in Rails.

### `POST /api/v1/questions`

**Request:**

```bash
curl -X POST http://localhost:3000/api/v1/questions \
  -H "Content-Type: application/json" \
  -d '{"question": "What is Rails?"}'
```

**Response:**

```json
{
  "data": {
    "question": "What is Rails?",
    "answer": "Based on the uploaded content: ...",
    "confidence": 0.72,
    "sources": [
      { "rank": 1, "document_title": "Rails Guide", "section": 2, "score": 0.72 },
      { "rank": 2, "document_title": "Rails Guide", "section": 1, "score": 0.58 }
    ]
  }
}
```

The response is formatted through `AnswerSerializer` to keep the controller thin and the JSON structure consistent.

| Status | Meaning |
|--------|---------|
| `200`  | Answer returned successfully |
| `422`  | Question parameter is blank |
| `503`  | No documents have been processed yet |

## Project structure (important parts)

- `app/models/document.rb` - document lifecycle and processing trigger
- `app/models/chunk.rb` - chunk storage + vector payload
- `app/jobs/document_processing_job.rb` - async processing pipeline
- `app/services/chunker.rb` - text splitting and overlap
- `app/services/vectorizer.rb` - TF-IDF-like vector simulation
- `app/services/retriever.rb` - cosine-similarity ranking
- `app/services/answer_builder.rb` - answer + sources formatter
- `app/controllers/documents_controller.rb` - ingestion flow
- `app/controllers/questions_controller.rb` - retrieval flow (HTML)
- `app/controllers/api/v1/questions_controller.rb` - retrieval API (JSON)
- `app/serializers/answer_serializer.rb` - JSON response formatter

## Run checks

```bash
bundle exec rubocop
bundle exec rspec
```

## Tradeoffs and limitations

- **Simple and explainable:** easy to debug and reason about, good for assignment scope.
- **No semantic understanding:** retrieval is lexical (word overlap), so paraphrases can be missed.
- **Extractive answers:** output is assembled from chunks, not fully natural language generation.
- **Linear scan retrieval:** current approach compares against all chunks, which is okay for small datasets but not ideal at large scale.

## Bonus / extra effort

- **RSpec test suite** — models, services, jobs, serializer, and API request specs (47 examples total). Chose RSpec over Minitest for readability and expressive matchers.
- **JSON API (`POST /api/v1/questions`)** — added a versioned API endpoint to demonstrate how I structure APIs in Rails: namespaced controllers, a lightweight base controller (`ActionController::API`), and proper HTTP status codes.
- **Serializer layer (`AnswerSerializer`)** — response formatting lives in its own class instead of inline in the controller. Keeps the controller thin and makes the JSON contract easy to test and change independently.
- **CI pipeline (GitHub Actions)** — automated RuboCop linting and RSpec on every push/PR.
- **dotenv for config** — database credentials read from environment variables, no secrets hardcoded in committed files.

## Future improvements

- Improve scoring (token-level IDF, BM25-like ranking).
- Add document-level filtering for targeted search.
- Add end-to-end request/integration tests.
