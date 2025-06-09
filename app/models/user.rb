class User < ApplicationRecord
  # has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :user_likes_cat_facts
  validates :username, presence: true, uniqueness: true

  def likes?(fact_id)
    self.user_likes_cat_facts.exists?(fact_id: fact_id)
  end
end
