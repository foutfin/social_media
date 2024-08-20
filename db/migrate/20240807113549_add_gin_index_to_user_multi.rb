class AddGinIndexToUserMulti < ActiveRecord::Migration[6.1]
  def up
    enable_extension("pg_trgm");
    add_index :users, [:first_name , :last_name , :username ], using: :gin , opclass: :gin_trgm_ops

  end

  def down
    remove_index :users, [ :first_name , :last_name , :username ]
  end
end
