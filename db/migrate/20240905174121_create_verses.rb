class CreateVerses < ActiveRecord::Migration[7.1]
  def change
    create_table :verses do |t|
      t.string :book
      t.integer :chapter
      t.integer :verse_number
      t.string :text

      t.timestamps
    end
  end
end
