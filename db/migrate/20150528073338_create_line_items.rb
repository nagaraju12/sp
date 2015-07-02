class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.references :product, index: true, foreign_key: true
      t.belongs_to :cart, index: true, foreign_key: true
      t.integer :product_id
      t.integer :cart_id
      t.decimal  "unit_price",         :precision => 7, :scale => 2
      t.timestamps null: false
    end
  end
end
