class CreateSeasons < ActiveRecord::Migration[7.1]
  def change
    create_table :seasons do |t|
      t.string :title
      t.references :series, null: false, foreign_key: true

      t.timestamps
    end
  end
end
