class Season < ApplicationRecord
  belongs_to :series
  has_many :episodes, dependent: :destroy

  accepts_nested_attributes_for :episodes, allow_destroy: true
end
