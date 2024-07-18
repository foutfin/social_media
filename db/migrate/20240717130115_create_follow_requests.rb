class CreateFollowRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :follow_requests do |t|
      t.references :from, null: false, foreign_key: { to_table: :users} 
      t.references :to, null: false, foreign_key: { to_table: :users}
      t.boolean :approved

      t.timestamps
    end
  end
end
