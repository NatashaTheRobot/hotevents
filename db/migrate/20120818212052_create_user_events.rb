class CreateUserEvents < ActiveRecord::Migration
  def change
    create_table :user_events do |t|
      t.references :user
      t.references :event
      t.string :rsvp_status
      t.string :teaser_users
      t.integer :num_friends_attending
      t.integer :num_friends_maybe
      t.integer :num_friends_invited

      t.timestamps
    end
    add_index :user_events, :user_id
    add_index :user_events, :event_id
    add_index :user_events, [:user_id, :event_id], unique: true
    add_index :user_events, :num_friends_attending
    add_index :user_events, :num_friends_maybe
    add_index :user_events, :num_friends_invited
  end
end
