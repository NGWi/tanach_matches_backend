class CreateMatches < ActiveRecord::Migration[7.1]
  def change
    create_table :matches do |t|
      t.references :word, null: false, foreign_key: true
      t.references :matched_word, null: false, foreign_key: true

      t.timestamps
    end
  end
end
