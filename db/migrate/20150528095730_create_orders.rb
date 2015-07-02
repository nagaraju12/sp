class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :name
      t.text :address
      t.string :gender_type
      t.string :email
      t.string :password
      t.string :accno
      t.string :pay_type
      t.timestamps null: false
    end
  end
end
