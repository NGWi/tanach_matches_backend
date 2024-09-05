class CreateWords < ActiveRecord::Migration[7.1]
  def change
    create_table :words do |t|
      t.references :verse, null: false, foreign_key: true
      
      t.string :text
      t.integer :position

      t.timestamps
    end
  end
end
