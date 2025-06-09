class UserLikesCatFact < ApplicationRecord
  has_many :users
  validates_associated :users
  validates :user_id, :fact_id, presence: true
  validates :fact_id, comparison: { greater_than: 0 }
  validates_uniqueness_of :user_id, scope: :fact_id
end
