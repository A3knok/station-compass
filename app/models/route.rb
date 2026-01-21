class Route < ApplicationRecord
  # Uploaderをマウント
  mount_uploaders :images, ::RouteUploader

  belongs_to :user
  belongs_to :gate, optional: true # 自動バリデーションを無効化
  belongs_to :exit, optional: true # 自動バリデーションを無効化
  belongs_to :category, optional: true # 自動バリデーションを無効化

  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :helpful_marks, dependent: :destroy

  validates :gate_id, presence: true
  validates :exit_id, presence: true
  validates :description, presence: true, length: { minimum: 10, maximum: 1000 }
  validates :estimated_time, presence: true, numericality: { only_integer: true, greater_than: 0 }

  # 文字列を配列に変換
  def tag_names=(names) #
    return if names.blank?

    tag_names = names.split(",").map(&:strip).uniq.reject(&:blank?) # 配列で返す

    self.tags.clear # 既存タグ削除(ルート編集時に古いタグを残さないため)

    tag_names.each do |tag_name|
      # メソッドの戻り値となる配列
      tag = Tag.find_or_create_by(name: tag_name.downcase) # 小文字に変換
      self.tags << tag unless self.tags.include?(tag)
    end
  end

  # 配列を文字列に変換
  def tag_names
    tags.pluck(:name).join(",")
  end

  def helpful_by?(user)
    helpful_marks.exists?(user_id: user.id)
  end

  def helpful_count
    helpful_marks.count
  end

  # ホワイトリストの管理
  def self.ransackable_attributes(auth_object = nil)
    [ "exit_id", "gate_id" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "gate", "exit" ]
  end
end
