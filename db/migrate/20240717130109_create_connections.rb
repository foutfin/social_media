class CreateConnections < ActiveRecord::Migration[6.1]
  def change
    create_table :connections do |t|
      t.references :follow_by, null: false, foreign_key: { to_table: :users } 
      t.references :follow_to, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
