class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :caption
      t.text :body
      t.boolean :archived
      t.integer :likes
      t.integer :dislikes
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
