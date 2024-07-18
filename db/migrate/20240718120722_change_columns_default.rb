class ChangeColumnsDefault < ActiveRecord::Migration[6.1]
  def change
    change_column_default :posts , :likes , from: nil, to: 0
    change_column_default :posts , :dislikes , from: nil, to: 0
    change_column_default :posts , :archived , from: nil, to: false
  end
end
