class CreateWords < ActiveRecord::Migration[7.1]
  def change
    create_table :words do |t|
      t.string :text
      t.integer :position

      t.timestamps
    end
  end
end
