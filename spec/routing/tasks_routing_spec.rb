require "rails_helper"

RSpec.describe Project::TasksController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/projects/1/tasks").to route_to("project/tasks#index", project_id: '1')
    end

    it "routes to #show" do
      expect(get: "/projects/1/tasks/1").to route_to("project/tasks#show", id: "1", project_id: '1')
    end

    it "routes to #edit" do
      expect(get: "/projects/1/tasks/1/edit").to route_to("project/tasks#edit", id: "1", project_id: '1')
    end

    it "routes to #create" do
      expect(post: "/projects/1/tasks").to route_to("project/tasks#create", project_id: '1')
    end

    it "routes to #update via PUT" do
      expect(put: "/projects/1/tasks/1").to route_to("project/tasks#update", id: "1", project_id: '1')
    end

    it "routes to #update via PATCH" do
      expect(patch: "/projects/1/tasks/1").to route_to("project/tasks#update", id: "1", project_id: '1')
    end

    it "routes to #destroy" do
      expect(delete: "/projects/1/tasks/1").to route_to("project/tasks#destroy", id: "1", project_id: '1')
    end
  end
end
