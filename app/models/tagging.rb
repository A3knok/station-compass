class Tagging < ApplicationRecord
  belongs_to :tag
  belongs_to :route

  validates :tag_id, uniqueness: { scope: :route_id }

  def self.ransackable_associations(auth_object = nil)
    [ "tag", "route" ]
  end
end
