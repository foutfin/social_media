class DropResources < ActiveRecord::Migration[6.1]
  def change
    drop_table :resources
  end
end
