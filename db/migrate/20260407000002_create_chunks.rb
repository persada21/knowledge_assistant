class CreateChunks < ActiveRecord::Migration[8.0]
  def change
    create_table :chunks do |t|
      t.references :document, null: false, foreign_key: true
      t.text    :body,        null: false
      t.integer :chunk_index, null: false
      t.jsonb   :vector,      default: {}
      t.integer :word_count,  default: 0

      t.timestamps
    end

    add_index :chunks, %i[document_id chunk_index]
    add_index :chunks, :vector, using: :gin
  end
end
