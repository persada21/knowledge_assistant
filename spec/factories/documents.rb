FactoryBot.define do
  factory :document do
    title { "Test Document" }
    original_text do
      <<~TEXT
        Ruby on Rails is a full-stack web framework. It follows the MVC pattern and emphasizes convention over configuration.

        Rails provides tools for building database-backed web applications. It includes libraries for routing, views, and models.

        The framework was created by David Heinemeier Hansson and released in 2004. It has since become one of the most popular frameworks.
      TEXT
    end
  end
end
