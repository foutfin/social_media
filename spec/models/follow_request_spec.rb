require 'rails_helper'

RSpec.describe FollowRequest, type: :model do
   u1 = User.new(
      first_name:"test",
      last_name:"test",
      username:"tests",
      password:"1234567",
      password_confirmation:"1234567",
      email:"abc@abc.com"
    )
   u2 = User.new(
      first_name:"te",
      last_name:"test",
      username:"tets",
      password:"1234567",
      password_confirmation:"1234567",
      email:"ac@abc.com"
    )
  subject {
    described_class.new(from:u1,to:u2)
  }
  it " is valid with valid attributes " do
    expect(subject).to be_valid
  end

  it " is not valid without from " do
    subject.from = nil
    expect(subject).to_not be_valid
  end
  
  it " is not valid without to " do
    subject.from = nil
    expect(subject).to_not be_valid
  end

  it { expect(described_class.reflect_on_association(:from).macro).to eq(:belongs_to) } 
  it { expect(described_class.reflect_on_association(:to).macro).to eq(:belongs_to) } 
end
