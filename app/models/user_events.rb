# == Schema Information
#
# Table name: user_events
#
#  id                    :integer          not null, primary key
#  user_id               :integer
#  event_id              :integer
#  rsvp_status           :string(255)
#  teaser_users          :string(255)
#  num_friends_attending :integer
#  num_friends_maybe     :integer
#  num_friends_invited   :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class UserEvents < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  attr_accessible :num_friends_attending, :num_friends_invited, :num_friends_maybe, :rsvp_status, :teaser_users
end
