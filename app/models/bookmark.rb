class Bookmark < ApplicationRecord
  belongs_to :bookmarkable, polymorphic: true
  belongs_to :list

  #validates :bookmarkable, uniqueness: { scope: :list }
  #validates :comment, length: { minimum: 5 }
end
