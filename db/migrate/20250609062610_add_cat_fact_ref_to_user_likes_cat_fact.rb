class AddCatFactRefToUserLikesCatFact < ActiveRecord::Migration[8.0]
  def change
    add_column :user_likes_cat_facts, :fact_id, :integer
  end
end
