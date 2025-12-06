class AddFieldsToSeasons < ActiveRecord::Migration[7.1]
  def change
    add_column :seasons, :season_number, :integer
  end
end
