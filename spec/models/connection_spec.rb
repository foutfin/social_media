require 'rails_helper'

RSpec.describe Connection, type: :model do
  it { expect(described_class.reflect_on_association(:follow_by).macro).to eq(:belongs_to) } 
  it { expect(described_class.reflect_on_association(:follow_to).macro).to eq(:belongs_to) } 
  it { expect(described_class.reflect_on_association(:posts).macro).to eq(:has_many) } 
end
