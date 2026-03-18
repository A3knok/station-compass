class Route < ApplicationRecord
  # Uploaderをマウント
  mount_uploaders :images, ::RouteUploader

  belongs_to :user
  belongs_to :gate
  belongs_to :exit
  belongs_to :category, optional: true # 自動バリデーションを無効化

  # Gateを通じてstationにアクセス
  has_one :station, through: :gate

  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :helpful_marks, dependent: :destroy

  validates :description, presence: true, length: { minimum: 10, maximum: 1000 }
  validates :estimated_time, presence: true, numericality: { only_integer: true, greater_than: 0 }

  # 文字列を配列に変換
  def tag_names=(names)
    return if names.blank?

    # タグ名の配列を取得
    tag_names_array = parse_tag_names(names)

    assign_tags(tag_names_array)
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

  # 画像を更新するためのメソッド
  def update_images(new_image_params)
    return unless new_image_params.present?

    valid_images = new_image_params.reject(&:blank?)
    self.images = valid_images if valid_images.any?
  end

  # ホワイトリストの管理
  def self.ransackable_attributes(auth_object = nil)
    [ "exit_id", "gate_id", "category_id" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "gate", "exit", "tags", "taggings", "station", "category" ]
  end

  private

  # タグ名の文字列を配列に変換する
  def parse_tag_names(names)
    names.split(",") # カンマで文字列を区切って分割
          .map(&:strip) # 前後の空白を削除
          .uniq # 重複を排除
          .reject(&:blank?) # 空文字を削除
  end

  def assign_tags(tag_names_array)
    self.tags.clear # 既存タグ削除(ルート編集時に古いタグを残さないため)

    tag_names_array.each do |tag_name|
      # メソッドの戻り値となる配列
      tag = Tag.find_or_create_by(name: tag_name.downcase) # 小文字に変換
      self.tags << tag unless self.tags.include?(tag)
    end
  end
end
