# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  start_time  :datetime
#  end_time    :datetime
#  timezone    :string(255)
#  location    :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  fb_event_id :integer
#

require 'spec_helper'

describe Event do
  pending "add some examples to (or delete) #{__FILE__}"
end
