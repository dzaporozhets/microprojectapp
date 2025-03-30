require 'rails_helper'
require 'icalendar'
require 'calendar_task_exporter'

RSpec.describe CalendarTaskExporter do
  let(:project) { create(:project, name: "Test Project") }
  let(:task) do
    create(:task,
           name: "Sample Task",
           description: "This is a test task",
           due_date: Date.today,
           project: project)
  end

  let(:host) { "example.com" }

  subject(:exporter) { described_class.new(tasks: [task], host: host) }

  describe "#to_ical" do
    it "returns an Icalendar::Calendar object" do
      ical = exporter.to_ical
      expect(ical).to be_a(Icalendar::Calendar)
    end

    it "includes the task as an event" do
      ical = exporter.to_ical
      event = ical.events.first

      expect(event.summary).to eq(task.name)
      expect(event.description).to eq(task.description)
      expect(event.dtstart).to eq(Icalendar::Values::Date.new(task.due_date))
      expect(event.dtend).to eq(Icalendar::Values::Date.new(task.due_date))
      expect(event.location).to eq(project.name)
      expect(event.url.to_s).to include("example.com/projects/#{project.id}/tasks/#{task.id}")
    end

    it "sets calendar name and timezone" do
      ical = exporter.to_ical.to_ical

      expect(ical).to include("X-WR-CALNAME:MicroProjectApp Tasks")
      expect(ical).to include("BEGIN:VTIMEZONE")
    end
  end
end
