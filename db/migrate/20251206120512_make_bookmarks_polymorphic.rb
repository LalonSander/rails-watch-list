class MakeBookmarksPolymorphic < ActiveRecord::Migration[7.1]
  def change
    remove_reference :bookmarks, :movie, index: true, foreign_key: true

    add_reference :bookmarks, :bookmarkable, polymorphic: true, null: false, index: true
  end
end
