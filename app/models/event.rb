class Event < ActiveRecord::Base
  attr_accessible :end_time, :fb_event_id, :location, :name, :start_time, :timezone
end
