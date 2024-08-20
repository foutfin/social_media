class RemoveGinIndexToUser < ActiveRecord::Migration[6.1]
  def change
    remove_index :users , [ :first_name , :last_name , :username]
  end
end
