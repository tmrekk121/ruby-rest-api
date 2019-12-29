class User < ApplicationRecord
  validates :user_id, presence: true, length: { in: 6..20 }, uniqueness: true
  validates :password, presence: true, length: { in: 8..20 }, format: { with: /\A[!"#\$%&a-zA-Z0-9]+\z/ }
end
