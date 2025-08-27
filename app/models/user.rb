class User < ApplicationRecord
  has_secure_password
  validates :user_id, presence: true, uniqueness: true, length: { in: 6..20 },
            format: { with: /\A[a-zA-Z0-9]+\z/, message: "Incorrect character pattern" }
  validates :password, 
            presence: true, 
            length: { minimum: 8, maximum: 20 }, 
            on: :create,
            format: { with: /\A[\x21-\x7E]+\z/, message: "Incorrect character pattern" }
  validates :nickname,
            length: { maximum: 29 },
            allow_nil: true,
            on: :update
  validates :comment,
            length: { maximum: 99 },
            allow_nil: true,
            on: :update
end