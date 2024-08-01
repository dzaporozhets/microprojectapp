class Activity < ApplicationRecord
  belongs_to :trackable, polymorphic: true
  belongs_to :user, required: true
  belongs_to :project, required: true
end
