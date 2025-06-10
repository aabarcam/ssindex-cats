class CreateUserLikesCatFact < ActiveRecord::Migration[8.0]
  def change
    create_table :user_likes_cat_facts do |t|
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
