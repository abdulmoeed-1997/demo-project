class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|

      t.string "first_name", :limit => 25
      t.string "last_name", :limit => 25
      t.string "username", :default => '', :null => false
      t.string "email", :default => '', :null => false
      t.string "password_digest"
      t.boolean "active", :default => true

      t.timestamps
    end
  end
end
