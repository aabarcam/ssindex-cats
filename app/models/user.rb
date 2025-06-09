class User < ApplicationRecord
  # has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :user_likes_cat_facts
  validates :username, presence: true, uniqueness: true

  # normalizes :email_address, with: ->(e) { e.strip.downcase }
end
