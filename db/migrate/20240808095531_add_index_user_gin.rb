class AddIndexUserGin < ActiveRecord::Migration[6.1]
  def change
    enable_extension("pg_trgm");
    add_index :users, :first_name  , using: :gin , opclass: :gin_trgm_ops
    add_index :users, :last_name  , using: :gin , opclass: :gin_trgm_ops
  end
end
