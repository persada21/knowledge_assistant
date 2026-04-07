FactoryBot.define do
  factory :chunk do
    association :document
    body { "Ruby on Rails is a full-stack web framework for building modern applications." }
    chunk_index { 1 }
    vector { { "ruby" => 0.25, "rails" => 0.25, "framework" => 0.25, "web" => 0.25 } }
    word_count { 12 }
  end
end
