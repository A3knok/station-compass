# app/models/user.rb
class User < ApplicationRecord
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


  private

  # 新規作成 or パスワード更新かを判断
  def password_required?
    new_record? || password.present? || password_confirmation.present?
  end
end
