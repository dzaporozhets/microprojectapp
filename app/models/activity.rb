class Activity < ApplicationRecord
  belongs_to :trackable, polymorphic: true
  belongs_to :user, optional: false
  belongs_to :project, optional: false
end
