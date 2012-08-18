class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.datetime :start_time
      t.datetime :end_time
      t.string :timezone
      t.string :location

      t.timestamps
    end
    
    add_index :events, :name, unique: true
    add_index :events, :location
    add_column :events, :fb_event_id, :bigint, unique: true
  end
end
