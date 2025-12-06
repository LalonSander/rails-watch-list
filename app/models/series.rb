class Series < ApplicationRecord
  has_many :seasons, dependent: :destroy
  has_many :bookmarks, as: :bookmarkable, dependent: :destroy

  accepts_nested_attributes_for :seasons, allow_destroy: true

  validates :tmdb_id, presence: true
end
