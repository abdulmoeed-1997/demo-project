class CreateShoppingCarts < ActiveRecord::Migration[6.0]
  def change
    create_table :shopping_carts do |t|
      t.integer :user_id

      t.timestamps
    end
    add_index :shopping_carts, :user_id

  end
end
