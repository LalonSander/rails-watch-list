class AddFieldsToEpisodes < ActiveRecord::Migration[7.1]
  def change
    add_column :episodes, :overview, :text
    add_column :episodes, :episode_number, :integer
    add_column :episodes, :still_url, :string
    add_column :episodes, :rating, :float
  end
end
