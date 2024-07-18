class CreateResources < ActiveRecord::Migration[6.1]
  def change
    create_table :resources do |t|
      t.references :post, null: false, foreign_key: true
      t.string :title
      t.string :url

      t.timestamps
    end
  end
end
