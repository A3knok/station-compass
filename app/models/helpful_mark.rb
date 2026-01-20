class HelpfulMark < ApplicationRecord
  belongs_to :user
  belongs_to :route, counter_cache: true

  validates :user_id, uniqueness: { scope: :route_id }
end
