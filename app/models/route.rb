class Route < ApplicationRecord
  belongs_to :user
  belongs_to :gate, optional: true # 自動バリデーションを無効化
  belongs_to :exit, optional: true # 自動バリデーションを無効化
  belongs_to :category, optional: true # 自動バリデーションを無効化
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  validates :gate_id, presence: true
  validates :exit_id, presence: true
  validates :description, presence: true, length: { minimum: 10, maximum: 1000 }
  validates :estimated_time, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def self.ransackable_attributes(auth_object = nil)
    [ "exit_id", "gate_id" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "gate", "exit" ]
  end
end
