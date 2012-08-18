class UserEvents < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  attr_accessible :num_friends_attending, :num_friends_invited, :num_friends_maybe, :rsvp_status, :teaser_users
end
