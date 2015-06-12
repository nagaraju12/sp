class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title
      t.text :description
      t.decimal :price
      t.string :category_id
       t.string :comment_id
      t.timestamps null: false
    end
  end
end
