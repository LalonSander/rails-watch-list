class AddFieldsToSeries < ActiveRecord::Migration[7.1]
  def change
    add_column :series, :overview, :text
    add_column :series, :poster_url, :string
    add_column :series, :rating, :float
    add_column :series, :tmdb_id, :integer
  end
end
