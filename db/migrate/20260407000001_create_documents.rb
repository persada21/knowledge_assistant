class CreateDocuments < ActiveRecord::Migration[8.0]
  def change
    create_table :documents do |t|
      t.string  :title,         null: false
      t.text    :original_text, null: false
      t.integer :chunk_count,   default: 0

      t.timestamps
    end
  end
end
