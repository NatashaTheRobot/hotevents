class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :token
      t.integer :expires_at
      t.string :first_name
      t.string :last_name
      t.integer :fb_id
      t.string :email

      t.timestamps
    end
    
    add_index :users, :token, unique: true
    add_index :users, :fb_id, unique: true
    add_index :users, :email, unique: true
  end
end
