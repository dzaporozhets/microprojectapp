require "rails_helper"

RSpec.describe ApplicationRecord do
  it "inherits from ActiveRecord::Base" do
    expect(described_class.superclass).to eq(ActiveRecord::Base)
  end

  it "is an abstract class" do
    expect(described_class).to be_abstract_class
  end
end
