class CreateCoupons < ActiveRecord::Migration[6.0]
  def change
    create_table :coupons do |t|
      t.string :key
      t.decimal :value, precision:5, scale: 2, :default=>0

      t.timestamps
    end
  end
end
