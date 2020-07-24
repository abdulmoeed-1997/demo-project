class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.integer :price
      t.integer :user_id
      t.integer :category_id
      t.string  :serial_no, :default => ''
      t.integer :quantity, :default => 1
      t.timestamps
    end
    add_index("products",["user_id","category_id","serial_no"])
  end

end
