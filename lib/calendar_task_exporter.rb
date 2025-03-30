# lib/calendar_task_exporter.rb
require 'icalendar'
require 'icalendar/tzinfo'

class CalendarTaskExporter
  def initialize(tasks:, host:)
    @tasks = tasks
    @host = host
  end

  def to_ical
    calendar = Icalendar::Calendar.new
    calendar.prodid = "-//MicroProjectApp//Calendar//EN"
    calendar.append_custom_property("X-WR-CALNAME", "MicroProjectApp Tasks")

    timezone = TZInfo::Timezone.get("UTC").ical_timezone(Time.current)
    calendar.add_timezone(timezone)

    @tasks.each do |task|
      calendar.add_event(build_event(task))
    end

    calendar
  end

  private

  def build_event(task)
    Icalendar::Event.new.tap do |event|
      event.dtstart     = Icalendar::Values::Date.new(task.due_date)
      event.dtend       = Icalendar::Values::Date.new(task.due_date)
      event.summary     = task.name
      event.description = task.description if task.description.present?
      event.uid         = "task-#{task.id}@microprojectapp"
      event.url         = Rails.application.routes.url_helpers.details_project_task_url(
                            task.project, task, host: @host
                          )
      event.location    = task.project.name if task.project.present?
    end
  end
end
