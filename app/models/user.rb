# app/models/user.rb
class User < ApplicationRecord
  has_many :routes, dependent: :destroy
  has_many :helpful_marks, dependent: :destroy
  has_many :helpful_routes, through: :helpful_marks, source: :route
  has_many :contacts, dependent: :destroy
  # validatableを除外してカスタマイズ
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable

  # カスタムバリデーション
  validates :name, presence: true
  validates :email, presence: true,
                    # emailの正規表現にマッチするか
                    format: { with: URI::MailTo::EMAIL_REGEXP },
                    uniqueness: true
  validates :password, presence: true,
                      length: { minimum: 6 },
                      # 2つのフォームで入力された内容が完全に一致するかを検証
                      confirmation: true,
                      if: :password_required?
  validates :password_confirmation, presence: true, if: :password_required?
  validate :forbid_guest_email # ゲストユーザーのみ使用できるメールアドレス

  # ゲストユーザー作成メソッド
  def self.guest_user
    find_or_create_by!(email: "guest@example.com") do |user|
      user.name = "ゲストユーザー"
      user.password = SecureRandom.urlsafe_base64
      user.password_confirmation = user.password
      user.guest = true
    end
  end

  # ゲストユーザーか判定する
  def guest?
    guest == true
  end

  private

  # 新規作成 or パスワード更新かを判断
  def password_required?
    new_record? || password.present? || password_confirmation.present?
  end

  # 一般ユーザーにゲストユーザーのメールアドレスを使って登録させない
  def forbid_guest_email
    if email == "guest@example.com" && !guest # !guestは一派ユーザー
      errors.add(:email, "このメールアドレスは使用できません")
    end
  end
end
