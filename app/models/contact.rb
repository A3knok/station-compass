class Contact < ApplicationRecord
  validates :subject, presence: true
  validates :body, presence: true, length: { minimum: 10 }
end
