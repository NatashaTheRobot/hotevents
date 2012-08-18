class EventsController < ApplicationController
  def index
    @events = UserEvents.find_all_by_user_id(current_user.id)
  end
end
