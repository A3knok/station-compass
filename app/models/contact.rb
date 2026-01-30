class Contact < ApplicationRecord
  belongs_to :user

  validates :subject, presence: true
  validates :body, presence: true, length: { minimum: 10 }
end
