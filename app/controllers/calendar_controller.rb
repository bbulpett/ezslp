class CalendarController < ApplicationController
  authorize_resource :class => false
  def index
    @month = (params[:month] || (Time.zone || Time).now.month).to_i
    @year = (params[:year] || (Time.zone || Time).now.year).to_i
    @shown_month = Date.civil(@year, @month)
    @event_strips = current_user.organization.events.event_strips_for_month(@shown_month)
  end
end
#event-calendar gem
#see app/model/event.rb app/helpers/calendar_helper.rb
#see db/migrate/create_events
