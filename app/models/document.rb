class Document < ApplicationRecord
  belongs_to :user
  belongs_to :project

  has_paper_trail
end
