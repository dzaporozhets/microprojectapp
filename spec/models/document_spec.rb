require 'rails_helper'

RSpec.describe Document, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:project) }
end
