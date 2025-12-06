class Episode < ApplicationRecord
  belongs_to :season
  has_one :series, through: :season
end
