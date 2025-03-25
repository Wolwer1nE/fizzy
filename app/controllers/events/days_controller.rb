class Events::DaysController < ApplicationController
  include EventsTimeline

  def index
    @events = events_for_activity_day
    @next_day = latest_event_before_activity_day&.created_at
  end
end
